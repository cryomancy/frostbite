_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.services.networkd-dispatcher;
in {
  options = {
    frostbite.networking.services.networkd-dispatcher = lib.mkOption {
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
    # Allows executing scripts in response to interface changes
    services = {
      networkd-dispatcher = {
        enable = true;
        rules = {};
      };
    };
  };
}
