_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.security.polkit;
  secOpts = config.frostbite.security.settings;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    frostbite.security.polkit = lib.mkOption {
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
    security = {
      polkit = {
        enable = !isOpen true;
      };
    };
  };
}
