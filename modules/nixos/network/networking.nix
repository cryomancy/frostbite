{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.networking;
in {
  options = {
    kosei.networking = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
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
        enable = true;

        wait-online = {
          enable = true;
          anyInterface = true;
          timeout = 10;
          ignoredInterfaces = [
            "nm_managed"
          ];
        };

        networks = {
          "40-dhcp" = {
            matchConfig = {
              Name = "dhcp_vlan";
            };
            networkConfig = {
              DHCP = "ipv4";
            };
            linkConfig.RequiredForOnline = "no";
          };

          "40-static" = (lib.mkIf cfg.ipAddr != null && cfg.gateway != null) {
            matchConfig = {
              Name = "static_vlan";
            };
            networkConfig = {
              Address = "${cfg.ipAddr}";
              Gateway = "${cfg.gateway}";
            };
            linkConfig.RequiredForOnline = "no";
          };

          "40-nm_managed" = {
            enable = false;
            matchConfig = {
              Name = "nm_vlan";
            };
            networkConfig = {
              Bridge = "br0";
            };
            linkConfig.RequiredForOnline = "enslaved";
          };

          "40-br0" = {
            matchConfig.Name = "br0";
            bridgeConfig = {};
            linkConfig = {
              RequiredForOnline = "carrier";
            };
          };
        };

        netdevs = {
          "20-dhcp_vlan_netdev" = {
            netdevConfig = {
              Kind = "vlan";
              Name = "dhcp_vlan";
            };
            vlanConfig = {
              Id = 10;
              Device = "wlo1";
            };
          };

          "20-static_vlan_netdev" = {
            netdevConfig = {
              Kind = "vlan";
              Name = "static_vlan";
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

          "25-br0" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
            };
          };

          "25-container-macvlan" = {
            Kind = "macvlan";
            Name = "container-macvlan";
            macvlanConfig = {
              Mode = "bridge";
            };
          };
        };
      };

      services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
    };

    networking = {
      useNetworkd = true;

      networkd = {
        networks."nm_unmanaged" = {
          matchConfig.Name = "nm_unmanaged";
          linkConfig.Unmanaged = "yes";
        };
      };

      usePredictableInterfaceNames = true;
      resolvconf.enable = false;
      useHostResolvConf = false;
      tempAddresses = "disabled";
      enableIPv6 = false;
      dhcpcd.enable = false;
    };

    environment.systemPackages = with pkgs; [
      gnome-control-center
      networkmanagerapplet
    ];

    services = {
      resolved.enable = true;
      networkd-dispatcher.enable = true;
    };
  };
}
