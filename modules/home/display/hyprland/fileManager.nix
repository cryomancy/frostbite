_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.displays.hyprland.fileManager;
in {
  options = {
    frostbite.frostbite.displays.hyprland.fileManager = {
      enable = lib.mkEnableOption "file manager";
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
