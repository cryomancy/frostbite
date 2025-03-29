_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.udev;
in {
  options = {
    frostbite.udev = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev = {
      enable = true;
    };
  };
}
