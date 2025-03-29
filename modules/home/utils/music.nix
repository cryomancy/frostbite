_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.utils.musoc;
in {
  options = {
    frostbite.frostbite.utils.music = {
      enable = lib.mkEnableOption "music packages";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # Music
        musescore
        audacity
      ];
    };
  };
}
