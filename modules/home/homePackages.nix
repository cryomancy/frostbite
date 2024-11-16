{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homePackages;
in {
  options = {
    homePackages = {
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
    ];
  };
}
