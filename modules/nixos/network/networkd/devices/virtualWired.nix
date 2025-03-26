_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.network.networkd.devices.virtualWired;
in {
  options = {
    kosei.network.networkd.devices.virtualWired = lib.mkOption {
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
        networks = {
          "20-wired-static" = {
            matchConfig = {
              Name = "wired_static_vlan";
            };
            networkConfig = {
              DNSSEC = "allow-downgrade";
            };
            linkConfig = {
              # NOTE: Jumbo Frames
              MTUBytes = 9014;
            };
          };

          # Manage by Networkd but can by configured ad-hoc by IWDGTK (IWD)
          "40-wired-dhcp" = {
            matchConfig = {
              Name = "wired_dhcp_vlan";
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
