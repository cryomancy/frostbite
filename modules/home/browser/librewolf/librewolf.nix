_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.browser.librewolf;
in {
  options = {
    frostbite.browser.librewolf = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
    };
  };
}
