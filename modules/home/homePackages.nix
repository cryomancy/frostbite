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
        description = "Whether to enable packages specific to fuyu";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      lynx
      audacity
      gimp-with-plugins
    ];
  };
}
