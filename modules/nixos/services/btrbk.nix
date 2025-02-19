scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.btrbk;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    kosei.btrbk = {
      enable = lib.mkEnableOption "btrbk";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = ["/var/snapshots"];
    };

    containers = {
      btrbk-container = {
        autoStart = true;
        config = _: {
          services.btrbk = {
            instances."btrbak" = {
              onCalendar = "*-*-* *:03:00";
              settings = {
                timestamp_format = "long";
                snapshot_preserve_min = "2d";
                preserve_day_of_week = "sunday";
                preserve_hour_of_day = "0";
                target_preserve = "48h 10d 4w 12m 10y";
                volume = {
                  "/" = {
                    snapshot_dir = "/var/snapshots";
                    subvolume = "home";
                  };
                };
              };
            };
          };
          systemd.tmpfiles.rules = [
            "d /var/snapshots 0755 root root"
          ];

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}
