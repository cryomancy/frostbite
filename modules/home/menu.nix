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
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        show-icons = true;
      };
    };
  };
}
