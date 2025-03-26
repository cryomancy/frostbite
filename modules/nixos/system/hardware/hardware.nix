scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.hardware;
in {
  options.kosei.hardware.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf cfg.enable {
    services.tcsd.enable = true;
    hardware = {
      enableAllFirmware = true;
      uinput.enable = true;
    };
  };
}
