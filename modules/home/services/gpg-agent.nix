_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.services.gpg-agent;
in {
  options = {
    frostbite.services.gpg-agent = {
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
