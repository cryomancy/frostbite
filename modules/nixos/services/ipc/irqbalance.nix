_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.ipc.irqbalance;
in {
  options = {
    frostbite.services.ipc.irqbalance = lib.mkOption {
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
    services = {
      irqbalance = {
        enable = true;
      };
    };
  };
}
