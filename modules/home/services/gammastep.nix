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
        provider = "geoclue2";
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
