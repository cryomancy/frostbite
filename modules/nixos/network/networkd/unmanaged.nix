_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networks.unmanaged;
in {
  options = {
    frostbite.networks.unmanaged = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.networks.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      network = {
        netdevs = {
          # Managed by NetworkManager
          "40-nm_managed" = {
            netdevConfig = {
              Description = "Logical seperation of wlo1 to be managed by Network Manager.";
              Name = "nm_managed";
              Kind = "ipvlan";
              MTUBytes = "9400";
            };
            ipvlanConfig = {
              Mode = "l3";
              Flag = "private";
            };
          };
        };
      };
    };
  };
}
