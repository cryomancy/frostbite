_: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frostbite.browser.chromium;
in {
  options = {
    frostbite.frostbite.browser.chromium = {
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
