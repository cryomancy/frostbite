scoped: {
  config,
  lib,
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
    services = {
      gammastep = {
        enable = true;
      };
    };
  };
}
