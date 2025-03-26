_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.services.ipc.irqbalance;
in {
  options = {
    kosei.services.ips.irqbalance = lib.mkOption {
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
