_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.irqbalance;
in {
  options = {
    frostbite.services.irqbalance = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
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
