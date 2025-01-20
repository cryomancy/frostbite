scoped: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.kosei.browser.lynx;
in {
  options = {
    kosei.browser = {
      lynx.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.w3m
      pkgs.lynx
    ];
  };
}
