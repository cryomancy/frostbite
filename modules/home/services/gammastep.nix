scoped: {
  config,
  lib,
  pkgs,
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
    home.packages = with pkgs; [geoclue2];
    services = {
      gammastep = {
        enable = true;
        provider = "geoclue2";
      };
    };
  };
}
