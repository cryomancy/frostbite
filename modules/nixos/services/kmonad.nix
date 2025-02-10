scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.kmonad;
in {
  options = {
    kosei.kmonad = {
      enable = lib.mkEnableOption "rgb";
    };
  };

  config = lib.mkIf cfg.enable {
    containers.kmonad = {
      autostart = true;
      config = {...}: {
        services.kmonad = {
          enable = true;
          keyboards = {
            all = {
              device = /dev/input/by-id;
              config = ''

              '';
            };
          };
        };
      };
    };
  };
}
