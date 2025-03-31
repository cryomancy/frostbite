_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.networkManager;
in {
  options = {
    frostbite.networking.networkManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      "nm_managed" = {
        configFile.path = "/etc/wpa_supplicant.conf";
        userControlled.group = "network";
        extraConf = ''
          ap_scan=1
        '';
        extraCmdArgs = "-u -W";
        bridge = "br0";
      };

      networkmanager = {
        enable = false;
        dns = "systemd-resolved";
        wifi = {
          backend = "iwd";
          scanRandMacAddress = true;
          powersave = false;
          macAddress = "random";
        };
      };
    };
  };
}
