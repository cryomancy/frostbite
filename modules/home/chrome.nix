scoped: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.kosei.browser.chrome;
in {
  options = {
    kosei.browser = {
      chrome.enable = lib.mkOption {
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
