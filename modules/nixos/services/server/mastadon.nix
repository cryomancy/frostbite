scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.mastadon;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    kosei.mastadon = {
      enable = lib.mkEnableOption "mastadon";
      email = lib.mkOption {
        type = lib.types.str;
        default = null;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = ["/var/lib/mastadon"];
    };

    # TODO: Asserts secrets must be enabled
    containers = {
      mastadon-container = {
        autoStart = true;
        config = _: {
          security.acme = {
            acceptTerms = true;
            defaults.email = cfg.email;
          };

          services = {
            mastadon = {
              enable = true;
              configureNginx = false;
              streamingProcesses = 7;
              smtp.fromAddress = cfg.email;
              webPort = 55001;
              extraConfig = {
                SINGLE_USER_MODE = "true";
              };
            };

            postgresqlBackup = {
              enable = true;
              databases = ["mastodon"];
            };

            # Caddy systemd unit needs readwrite permissions to /run/mastodon-web
            systemd.services.caddy.serviceConfig.ReadWriteDirectories = lib.mkForce ["/var/lib/caddy" "/run/mastodon-web"];
            users.users.caddy.extraGroups = ["mastodon"];
            caddy = {
              enable = true;
              virtualHosts = {
                "mastadon-container" = {
                  extraConfig = ''
                    handle_path /system/* {
                        file_server * {
                            root /var/lib/mastodon/public-system
                        }
                    }

                    handle /api/v1/streaming/* {
                        reverse_proxy  unix//run/mastodon-streaming/streaming.socket
                    }

                    route * {
                        file_server * {
                        root ${pkgs.mastodon}/public
                        pass_thru
                        }
                        reverse_proxy * unix//run/mastodon-web/web.socket
                    }

                    handle_errors {
                        root * ${pkgs.mastodon}/public
                        rewrite 500.html
                        file_server
                    }

                    encode gzip

                    header /* {
                        Strict-Transport-Security "max-age=31536000;"
                    }
                    header /emoji/* Cache-Control "public, max-age=31536000, immutable"
                    header /packs/* Cache-Control "public, max-age=31536000, immutable"
                    header /system/accounts/avatars/* Cache-Control "public, max-age=31536000, immutable"
                    header /system/media_attachments/files/* Cache-Control "public, max-age=31536000, immutable"
                  '';
                };
              };
            };
          };

          networking.firewall = {
            allowedTCPPorts = [80 443 55001];
          };

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}
