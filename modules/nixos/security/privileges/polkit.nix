_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.security.polkit;
  secOpts = config.frostbite.security;
  isSecure = secOpts.level != "open";
in {
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
        enable =
          if isSecure
          then true
          else false;
      };
    };
  };
}
