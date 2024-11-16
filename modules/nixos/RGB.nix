{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuRGB;
in {
  options = {
    fuyuRGB = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hardware.openrgb = {
      enable = true;
      server.port = 6742;
    };
  };
}
