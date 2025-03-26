_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.security.polkit;
  secOpts = config.kosei.security.settings;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    kosei.security.polkit = lib.mkOption {
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
