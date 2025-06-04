{
  networking = {
    useNetworkd = true;
    usePredictableInterfaceNames = true;
    resolvconf.enable = false;
    useHostResolvConf = false;
    tempAddresses = "disabled";
    enableIPv6 = false;
    dhcpcd.enable = false;

    wireless = {
      allowAuxiliaryImperativeNetworks = true;
      athUserRegulatoryDomain = true;
      iwd.enable = true;
    };
  };

  systemd = {
    network = {
      enable = true;

      wait-online = {
        enable = false;
      };

      netdevs = {
        "20-wireless" = {
          netdevConfig = {
            Name = "wireless_static";
            Kind = "ipvlan";
          };
        };

        "20-wireles-dhcp" = {
          netdevConfig = {
            Name = "wireless_dhcp";
            Kind = "ipvlan";
          };
        };
      };

      networks = {
        "20-wireless" = {
          matchConfig = {
            Name = "wireless_static";
          };
          networkConfig = {
            DNSSEC = "allow-downgrade";
          };
        };

        # Manage by Networkd but can by configured ad-hoc by IWDGTK (IWD)
        "20-wireless-dhcp" = {
          matchConfig = {
            Name = "wireless_dhcp";
          };
          networkConfig = {
            DHCP = "ipv4";
            DNSSEC = "allow-downgrade";
          };
        };
      };
    };
  };
}
