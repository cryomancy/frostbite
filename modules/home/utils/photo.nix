_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.utils.photo;
in {
  options = {
    frostbite.utils.photo = {
      enable = lib.mkEnableOption "photo packages";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        cheese
        aseprite
        inkscape
        blender
        gimp-with-plugins
        obsidian
        via
      ];
    };
  };
}
