_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.system.systemd.udev;
in {
  options = {
    kosei.system.systemd.udev = lib.mkOption {
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
