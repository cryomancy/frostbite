_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.network.networkd.devices.virtualWireless;
in {
  options = {
    kosei.network.networkd.devices.virtualWireless = lib.mkOption {
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
    assertions = import ./__assertions.nix {inherit lib;};

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
