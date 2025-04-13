_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.network.networkd.devices.virtualWireless;
in {
  options = {
    frostbite.network.networkd.devices.virtualWireless = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.networking.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      network = {
        networks = {
          "20-wireless-static" = {
            matchConfig = {
              Name = "wireless_static_vlan";
            };
            networkConfig = {
              DNSSEC = "allow-downgrade";
            };
            linkConfig = {
              requiredForOnline = "routable";
            };
          };

          # Manage by Networkd but can by configured ad-hoc by IWDGTK (IWD)
          "40-wireless-dhcp" = {
            matchConfig = {
              Name = "wireless_dhcp_vlan";
            };
            networkConfig = {
              DHCP = "ipv4";
              DNSSEC = "allow-downgrade";
            };
            linkConfig.RequiredForOnline = "routable";
          };
        };
      };
    };
  };
}
