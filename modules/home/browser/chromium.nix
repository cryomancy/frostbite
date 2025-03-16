scoped: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.kosei.chromium;
in {
  options = {
    kosei.chromium = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };
}
