_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.networks.wireless;
in {
  options = {
    frostbite.networks.wireless = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      additionalWhistelistedInterfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = ["wlp7s0"];
      };

      pci = lib.mkOption {
        type = lib.types.str;
        example = "pci-0000:00:14.3*";
      };
      # home = {

      # SSID = lib.mkOption {
      #  type = lib.types.str;
      #  example = "NSA_VAN";
      # };
      # staticIP = lib.mkOption {
      #  type = lib.types.str;
      #  example = "192.168.100.10/24";
      # };
      # gateway = lib.mkOption {
      #  type = lib.types.str;
      #  example = "192.168.100.1";
      # };
      # };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      # NOTE: This is redundant.
      useNetworkd = true;
      usePredictableInterfaceNames = true;
      resolvconf.enable = false;
      useHostResolvConf = false;
      tempAddresses = "disabled";
      enableIPv6 = false;
      dhcpcd.enable = false;

      nameservers = ["1.1.1.1"];
      wireless = {
        iwd = {
          enable = true;
          settings = {
            Network = {
              EnableIPv6 = false;
              RoutePriorityOffset = 300;
              NameResolvingService = "systemd";
            };
            Settings = {
              AutoConnect = true;
            };
          };
        };
        interfaces = ["wlan0" "wireless"] ++ cfg.additionalWhitelistedInterfaces;
      };
    };

    environment.systemPackages = [pkgs.iwgtk];

    services.resolved.enable = true;

    systemd.network = {
      enable = true;
      wait-online.enable = false;

      links = {
        "10-rename-wlo1" = {
          matchConfig.Path = "${cfg.pci}";
          linkConfig.Name = "wireless";
        };
      };

      networks = {
        "25-wireless" = {
          matchConfig = {
            Name = "wireless";
            # SSID = "${cfg.home.SSID}";
          };
          # address = ["${cfg.home.staticIP}"];
          # routes = [
          # {Gateway = "${cfg.home.gateway}";}
          # ];
          # dns = ["1.1.1.1"];
          networkConfig = {
            DHCP = "yes";
            # LinkLocalAddressing = "no";
          };
        };
      };
    };
  };
}
