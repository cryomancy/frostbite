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
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      audacity
      gimp-with-plugins
    ];
  };
}
