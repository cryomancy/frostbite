scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.nextcloud;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    kosei.nextcloud = {
      enable = lib.mkEnableOption "nextcloud";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = ["/var/snapshots"];
    };

    containers = {
      nextcloud-container = {
        autoStart = true;
        config = {
          config,
          pkgs,
          ...
        }: {
          services = {
            nextcloud = {
              enable = true;

              hostName = "nextcloud.tahlon.org";
              https = true;

              config = {
                adminpassFile = config.sops.secrets."$nextCloud/adminpass".path;
                dbtype = "sqlite";
              };

              package = pkgs.nextcloud28;
              extraApps = {
                inherit (config.services.nextcloud.package.packages.apps) news contacts calendar tasks;
              };
              extraAppsEnable = true;
            };

            nginx.virtualHosts.${config.services.nextcloud.hostName} = {
              forceSSL = true;
              enableACME = true;
            };
          };

          security.acme = {
            acceptTerms = true;
            certs = {
              ${config.services.nextcloud.hostName}.email = config.kosei.email;
            };
          };

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}
