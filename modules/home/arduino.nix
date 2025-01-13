scoped: {
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.kosei.arduino;
in {
  options = {
    kosei.arduino.enable = lib.mkEnableOption "arduino" {
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      arduino-cli
      arduino-ide
      digital
      simulide
    ];
  };
}
