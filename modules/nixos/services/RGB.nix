scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.RGB;
in {
  options = {
    kosei.RGB = {
      enable = lib.mkEnableOption "rgb";
    };
  };

  config = lib.mkIf cfg.enable {
    containers.openrgb = {
      autostart = true;
      config = {...}: {
        services.hardware.openrgb = {
          enable = true;
          server.port = 6742;
        };
      };
    };
  };
}
