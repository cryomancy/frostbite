_:
{
  config,
  lib,
  ...
}:
let
  cfg = config.frostbite.security.polkit;
in
{
  options = {
    frostbite.security.polkit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security = {
      polkit = {
        enable = true;
      };
    };
  };
}
