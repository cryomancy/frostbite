_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.display.hyprland.fileManager;
in {
  options = {
    frostbite.frostbite.display.hyprland.fileManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.display.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.kdePackages; [
      dolphin
      dolphin-plugins
      qtsvg
      qtwayland
      kio-fuse
      kio-extras
    ];
  };
}
