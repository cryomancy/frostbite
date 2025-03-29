_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.networkManager;
in {
  options = {
    frostbite.networking.networkManager = lib.mkOption {
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
