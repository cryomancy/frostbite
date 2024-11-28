{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.RGB;
in {
  options = {
    fuyuNoKosei.RGB = {
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
