_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.devices.macvlans;
in {
  options = {
    frostbite.networking.devices.macvlans = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.networking.enable;
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
