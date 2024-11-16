{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuMenu;
in {
  options = {
    fuyuMenu = {
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
