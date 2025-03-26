_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.bluetooth;
in {
  options = {
    kosei.networking.bluetooth = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = lib.mkIf (config.kosei.security.settings.useCase == "laptop");
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {};
    };

    services = {
      blueman.enable = true;
      gpsd.enable = true;
    };
  };
}
