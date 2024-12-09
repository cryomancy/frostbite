{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.menu;
in {
  options = {
    fuyuNoKosei.menu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.fuyuNoKosei.compositor.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland-unwrapped;
      extraConfig = {
        show-icons = true;
      };
    };
  };
}
