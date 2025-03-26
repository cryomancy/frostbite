_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.networkManager;
in {
  options = {
    kosei.networking.networkManager = lib.mkOption {
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
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        wifi = {
          backend = "iwd";
          scanRandMacAddress = true;
          powersave = false;
          macAddress = "random";
          unmanaged = [];
        };
      };
    };
  };
}
