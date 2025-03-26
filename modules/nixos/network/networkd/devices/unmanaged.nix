_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.networking.devices;
in {
  options = {
    kosei.networking.devices = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          ipAddr = lib.mkOption {
            type = lib.types.str;
            default = null;
          };
          gateway = lib.mkOption {
            type = lib.types.str;
            default = null;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = import ./__assertions.nix {inherit lib;};

    systemd = {
      network = {
        networks = {
          # Managed by NetworkManager
          "40-nm_managed" = {
            enable = false;
            matchConfig = {
              Name = "nm_vlan";
            };
            networkConfig = {
              Bridge = "br0";
            };
            linkConfig.RequiredForOnline = "enslaved";
          };
        };
      };
    };
  };
}
