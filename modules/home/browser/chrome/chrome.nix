_: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frostbite.browser.chrome;
in {
  options = {
    frostbite.browser.chrome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };
  };
}
