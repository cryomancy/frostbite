_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.networking.settings;
in {
  options = {
    frostbite.networking.settings = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome-control-center
      networkmanagerapplet
    ];

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

        services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";
      };
    };

    networking = {
      # NOTE: This is redundant.
      useNetworkd = true;

      allowAuxiliaryImperativeNetworks = true;
      usePredictableInterfaceNames = true;
      resolvconf.enable = false;
      useHostResolvConf = false;
      tempAddresses = "disabled";
      enableIPv6 = false;
      dhcpcd.enable = false;
    };
  };
}
