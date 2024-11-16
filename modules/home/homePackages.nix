{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuPackages;
in {
  options = {
    fuyuPackages = {
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
