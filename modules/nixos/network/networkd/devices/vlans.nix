_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.devices.vlans;
in {
  options = {
    kosei.networking.devices.vlans = lib.mkOption {
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
          "20-dhcp_vlan_netdev" = {
            netdevConfig = {
              Kind = "vlan";
              Name = "wireless_dhcp_vlan";
            };
            vlanConfig = {
              Id = 10;
              Device = "wlo1";
            };
          };

          "20-static_vlan_netdev" = {
            netdevConfig = {
              Kind = "vlan";
              Name = "wireless_static_vlan";
            };
            vlanConfig = {
              Id = 20;
              Device = "wlo1";
            };
          };

          "20-nm_vlan_netdev" = {
            netdevConfig = {
              Kind = "vlan";
              Name = "nm_vlan";
            };
            vlanConfig = {
              Id = 30;
              Device = "wlo1";
            };
          };
        };
      };
    };
  };
}
