_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.hardware.uinput;
in {
  options.frostbite.hardware.uinput.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      enableAllFirmware = true;
      uinput.enable = true;
    };
  };
}
