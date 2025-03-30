_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.irqbalance;
in {
  options = {
    frostbite.services.irqbalance = lib.mkOption {
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
