_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networks.wireless;
in {
  options = {
    frostbite.networks.wireless = {
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
          "20-wireless" = {
            matchConfig = {
              Name = "wireless_static";
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
