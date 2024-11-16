{
  config,
  lib,
  vars,
  ...
}: let
  cfg = config.hardware;
in {
  options = {
    hardware = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [vars.hostname];
  };
}
