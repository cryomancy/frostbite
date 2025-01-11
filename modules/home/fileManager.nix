scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.fileManager;
in {
  options = {
    kosei.fileManager = {
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
