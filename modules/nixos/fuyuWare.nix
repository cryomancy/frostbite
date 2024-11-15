{
  config,
  lib,
  vars,
  hostname,
  ...
}: let
  cfg = config.fuyuWare;
in {
  options = {
    fuyuWare = {
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
