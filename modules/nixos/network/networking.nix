_: {
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
	};
  };

  config = lib.mkIf cfg.enable {
    systemd.network = {
      enable = true;

      networks = {
      };

      netdevs = {
        "20-br0" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "br0";
          };
        };
      };
    };

    networking = {
      useNetworkd = true;

      usePredictableInterfaceNames = true;

      resolvconf.enable = false;
      useHostResolvConf = false;

      tempAddresses = "disabled";
      enableIPv6 = false;
      dhcpcd.enable = false;

      #tcpcrypt.enable = true;
      stevenblack.enable = true;

      # NOTE: Users can declare their wireless networks through
      #       networking.wireless.networks or imperatively
      # wireless = {
      #allowAuxiliaryImperativeNetworks = true;
      #secretsFile = config.sops.templates."network.conf".path;
      #networks =
      #  lib.attrsets.mergeAttrsList
      #  (lib.lists.forEach cfg.wirelessNetworks (
      #    network: {${network}.pskRaw = "ext:psk_${network}";}
      #  ));
      # };

      rxe = {
        enable = true;
      };

      timeServers = [
        "0.nixos.pool.ntp.org"
        "1.nixos.pool.ntp.org"
        "2.nixos.pool.ntp.org"
        "3.nixos.pool.ntp.org"
      ];

      nat = {
        enable = true;
        enableIPv6 = false;
        internalIPs = ["192.168.1.0/24"];
        internalInterfaces = [];
      };
    };

    hardware.bluetooth.enable = true;

    programs.openvpn3 = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnome-control-center
      networkmanagerapplet
    ];

    services = {
      avahi.enable = true;
      blueman.enable = true;
      resolved.enable = true;
      networkd-dispatcher.enable = true;
    };
  };
}
