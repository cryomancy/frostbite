_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.microphone;
in {
  options.kosei.microphone = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [easyeffects];
  };
}
