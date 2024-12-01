{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.gaming;
in {
  options = {
    fuyuNoKosei.gaming = {
      enable = lib.mkEnableOption "gaming";
    };
  };
  config = lib.mkIf cfg.enable {
    gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 15;
        };
        gpu = {
          apply_gpu_optimizations = "accept-responsibility";
          gpu_device = 0;
        };
      };
    };
    steam = lib.mkIf {
      enable = true;

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
    environment.systemPackages = with pkgs; [
      steamcmd
      steam-tui
      steam-run
      steamtinkerlaunch
    ];
  };
}
