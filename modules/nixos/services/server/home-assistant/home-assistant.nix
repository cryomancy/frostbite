_: {
  config,
  lib,
  inputs,
  pkgs,
  system,
  ...
}: let
  cfg = config.kosei.home-assistant;
  systemStateVersion = config.system.stateVersion;
  inherit config inputs pkgs;
in {
  options = {
    kosei.home-assistant = {
      enable = lib.mkEnableOption "home-assistant";
      domain = lib.mkOption {
        type = lib.types.str;
        default = null;
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = null;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        home-assistant-cli
      ];
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/".directories = ["/var/lib/hass"];
      };
    };

    # TODO: Asserts secrets must be enabled
    containers = {
      home-assistant-container = {
        autoStart = true;
        specialArgs = {inherit inputs;};
        config = {config, ...}: {
          services = {
            home-assistant = {
              enable = true;
              openFirewall = true;
              configDir = "/var/lib/hass";
              # default = config.contents;
              # defaultText = lib.literalExpression "contents";
              # Home Assistant has a monthly release schedule so
              # it is nice to receive those updates as soon as they
              # are released to everyone else.
              package = inputs.nixpkgs-master.legacyPackages.${system}.home-assistant;
              config = {
                homeassistant = {
                  unit_system = "metric";
                  temperature_unit = "C";
                  name = "Home-Server";
                  longitude = null;
                  latitude = null;
                };
              };

              lovelaceConfigWritable = false;
              lovelaceConfig = import ./__lovelace.nix;
              customLovelaceModules = with inputs.nixpkgs-master.legacyPackages.${system}.home-assistant-custom-lovelace-modules; [
                mini-graph-card
                mini-media-player
              ];

              defaultIntegrations = [
                "adobe"
                "application_credentials"
                "alert"
                "automation"
                "blueprint"
                "bluetooth"
                "calendar"
                "counter"
                "device_automation"
                "frontend"
                "hardware"
                "logger"
                "network"
                "system_health"
                "automation"
                "person"
                "plex"
                "scene"
                "script"
                "tag"
                "zone"
                "counter"
                "input_boolean"
                "input_button"
                "input_datetime"
                "input_number"
                "input_select"
                "input_text"
                "proximity"
                "schedule"
                "timer"
                "triggercmd"
                "backup"
              ];

              customComponents = with inputs.nixpkgs-master.legacyPackages.${system}.home-assistant-custom-components; [
                alarmo
                # mass
              ];

              # Reverse Proxy
              config = {
                http = {
                  server_host = "0.0.0.0";
                  server_port = 8123;
                  trusted_proxies = ["0.0.0.0"];
                  use_x_forwarded_for = true;
                };
              };
            };

            # Reverse Proxy
            nginx = {
              enable = true;
              recommendedProxySettings = true;
              # e.g. "home.tahlon.org"
              virtualHosts."home.${cfg.domain}" = {
                forceSSL = true;
                enableACME = true;
                extraConfig = ''
                  proxy_buffering off;
                '';
                locations."/" = {
                  proxyPass = "http://[0.0.0.0]:8123";
                  proxyWebsockets = true;
                };
              };
            };
          };

          security.acme = {
            acceptTerms = true;
            defaults.email = "tahlonbrahic@gmail.com";
          };

          nixpkgs.config.allowUnfree = true;

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}
