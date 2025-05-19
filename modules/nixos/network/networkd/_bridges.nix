_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.devices.bridges;
in {
  options = {
    frostbite.networking.devices.bridges = {
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
