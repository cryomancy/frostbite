{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.microphone;
in {
  options.fuyuNoKosei.microphone.enable = lib.mkEnableOption "microphone";

  config =
    lib.mkIf cfg.enable {
    };
}
