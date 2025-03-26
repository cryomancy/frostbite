_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.devices.macvlans;
in {
  options = {
    kosei.networking.devices.macvlans = lib.mkOption {
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
    systemd = {
      network = {
        netdevs = {
          "25-container-macvlan" = {
            Kind = "macvlan";
            Name = "container-macvlan";
            macvlanConfig = {
              Mode = "bridge";
            };
          };
        };
      };
    };
  };
}
