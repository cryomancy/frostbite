scoped: {
  config,
  lib,
  nixosConfig,
  ...
}: let
  cfg = config.kosei.gammastep;
in {
  options = {
    kosei.gammastep = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nixosConfig.services.geoclue2.enable = true;
    services = {
      gammastep = {
        enable = true;
        enableVerboseLogging = true;
        dawnTime = "6:00-7:45";
        duskTime = "18:35-20:15";
        provider = "manual";
        temperature = {
          day = 6000;
          night = 4600;
        };
        settings = {
          general.adjustment-method = "wayland";
        };
      };
    };
  };
}
