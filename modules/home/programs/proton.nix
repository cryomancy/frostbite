_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.programs.proton;
in {
  options = {
    frostbite.programs.proton = {
      enable = lib.mkEnableOption "proton packages";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        protonvpn-gui
        protonmail-desktop
      ];
    };
  };
}
