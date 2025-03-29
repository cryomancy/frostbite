_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.gaming.launchers;
in {
  options = {
    frostbite.gaming.launchers = {
      enable = lib.mkEnableOption "launchers";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      heroic
    ];
  };
}
