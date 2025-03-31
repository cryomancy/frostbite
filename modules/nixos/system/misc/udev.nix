_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.udev;
in {
  options = {
    frostbite.udev = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev = {
      enable = true;
    };
  };
}
