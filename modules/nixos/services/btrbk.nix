_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.btrbk;
in {
  options = {
    frostbite.services.btrbk = {
      enable = lib.mkEnableOption "btrbk";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/".directories = ["/var/snapshots"];
    };

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
  };
}
