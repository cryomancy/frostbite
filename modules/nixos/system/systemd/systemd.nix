_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.systemd;
in {
  options = {
    kosei.systemd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      ctrlAltDelUnit = "reboot.target";
    };
  };
}
