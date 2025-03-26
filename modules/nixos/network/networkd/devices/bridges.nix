_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.devices.bridges;
in {
  options = {
    kosei.networking.devices.bridges = lib.mkOption {
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
          "40-br0" = {
            matchConfig.Name = "br0";
            bridgeConfig = {};
            linkConfig = {
              RequiredForOnline = "carrier";
            };
          };
        };

        netdevs = {
          "25-br0" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
            };
          };
        };
      };
    };
  };
}
