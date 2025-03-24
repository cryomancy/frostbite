_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.microphone;
in {
  options.kosei.microphone.enable = lib.mkEnableOption "microphone";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [easyeffects];
  };
}
