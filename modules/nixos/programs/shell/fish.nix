_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.shell.fish;
in {
  options = {
    frostbite.shell.fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
      };
    };
  };
}
