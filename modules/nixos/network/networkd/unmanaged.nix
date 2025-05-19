_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.devices.unmanaged;
in {
  options = {
    frostbite.networking.devices.unmanaged = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.networking.enable;
      };
      ipAddr = lib.mkOption {
        type = lib.types.str;
        default = null;
      };
      gateway = lib.mkOption {
        type = lib.types.str;
        default = null;
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
