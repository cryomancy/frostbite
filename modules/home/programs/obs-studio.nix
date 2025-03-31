_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.programs.obs-studio;
in {
  options = {
    frostbite.programs.obs-studio = {
      enable = lib.mkEnableOption "obs-studio";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
          #obs-nvfbc
          obs-teleport
          obs-vkcapture
          obs-gstreamer
          obs-3d-effect
          input-overlay
          obs-multi-rtmp
          obs-source-clone
          obs-shaderfilter
          obs-source-record
          obs-livesplit-one
          looking-glass-obs
          obs-command-source
          obs-move-transition
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      };
    };
  };
}
