scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.gpg-agent;
in {
  options = {
    kosei.gpg-agent = {
      enable = lib.mkEnableOption "gpg-agent";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      gpg-agent = {
        enable = true;

        # TODO: make an option for TUI e.g. pinentry-curses
        pinentryPackage = pkgs.pinentry-gnome3;

        defaultCacheTtl = 60;
        maxCacheTtl = 120;

        enableBashIntegration = true;
        enableFishIntegration = true;
        enableScDaemon = true;
        enableSshSupport = true;
      };
    };
  };
}
