_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.gaming.steam;
in {
  options = {
    frostbite.gaming.steam = {
      enable = lib.mkEnableOption "steam";
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = true;
    programs = {
      steam = {
        enable = true;
        extest.enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        package = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              keyutils
              libkrb5
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
            ];
        };
      };
    };
    environment.systemPackages = with pkgs; [
      steamcmd
      steam-tui
      steam-run
      steamtinkerlaunch
      protonup
      protonplus
      protontricks
    ];
  };
}
