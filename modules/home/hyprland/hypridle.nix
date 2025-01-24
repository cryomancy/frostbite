scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.hypridle;
in {
  options = {
    kosei.hypridle = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
    };
  };
}
