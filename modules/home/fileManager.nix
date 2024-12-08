{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.fileManager;
in {
  options = {
    fuyuNoKosei.fileManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.fuyuNoKosei.compositor.enable;
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
