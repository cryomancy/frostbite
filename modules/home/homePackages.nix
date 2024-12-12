{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.homePackages;
in {
  options = {
    fuyuNoKosei.homePackages = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.fuyuNoKosei.compositor.enable;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      audacity
      gimp-with-plugins

      bitmagnet
      xd
    ];
  };
}
