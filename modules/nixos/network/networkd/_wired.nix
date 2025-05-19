_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networks.wired;
in {
  options = {
    frostbite.networks.wired = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.networks.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      network = {
        networks = {
          "20-wired-static" = {
            matchConfig = {
              Name = "wired_static";
            };
            networkConfig = {
              DNSSEC = "allow-downgrade";
            };
            linkConfig = {
              # NOTE: Jumbo Frames
              MTUBytes = 9014;
            };

	    networkConfig = {
	    
	    }
          };

          # Manage by Networkd but can by configured ad-hoc by IWDGTK (IWD)
          "40-wired-dhcp" = {
            matchConfig = {
              Name = "wired_dhcp";
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
