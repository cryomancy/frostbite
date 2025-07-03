_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.networks;
in {
  options = {
    frostbite.networks = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      network = {
        wait-online = {
          enable = false;
          anyInterface = true;
          timeout = 10;
          ignoredInterfaces = [
            "nm_managed"
          ];
        };
      };
    };

    networking = {
      # NOTE: This is redundant.
      useNetworkd = true;
      usePredictableInterfaceNames = true;
      resolvconf.enable = false;
      useHostResolvConf = false;
      tempAddresses = "disabled";
      enableIPv6 = false;
      dhcpcd.enable = false;

      wireless = {
        enable = true;
        iwd.enable = true;
      };
    };
  };
}
