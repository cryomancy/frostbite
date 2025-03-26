_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.services.networkd-dispatcher;
in {
  options = {
    kosei.networking.services.networkd-dispatcher = lib.mkOption {
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
