scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.fish;
in {
  options = {
    kosei.fish = {
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
