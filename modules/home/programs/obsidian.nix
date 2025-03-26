_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.programs.obsidian;
in {
  options = {
    frostbite.programs.obsidian = {
      enable = lib.mkEnableOption "obsidian";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        obsidian
      ];
    };
  };
}
