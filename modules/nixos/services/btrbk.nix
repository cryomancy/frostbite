scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.btrbk;
in {
  options = {
    kosei.btrbk = {
      enable = lib.mkEnableOption "btrbk";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
    ];

    containers = {
      btrbk-container = {
        autoStart = true;
        config = {...}: {
          services.btrbk = {
            instances."btrbak" = {
              onCalendar = "*-*-* *:03:00";
              settings = {
                timestamp_format = "long";
                snapshot_preserve_min = "2d";
                preserve_day_of_week = "sunday";
                preserve_hour_of_day = "0";
                target_preserve = "48h 10d 4w 12m 10y";
                volume."/home" = {
                  snapshot_create = "always";
                  subvolume = ".";
                  snapshot_dir = ".snapshots";
                };
                volume."/var/local" = {
                  snapshot_create = "always";
                  subvolume = ".";
                  snapshot_dir = ".snapshots";
                };
              };
            };
          };
        };
      };
    };
  };
}
