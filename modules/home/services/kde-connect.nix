scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.kde-connect;
in {
  options = {
    kosei.kde-connect = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Hide all .desktop, except for org.kde.kdeconnect.settings
    xdg.desktopEntries = {
      "org.kde.kdeconnect.sms" = {
        exec = "";
        name = "KDE Connect SMS";
        settings.NoDisplay = "true";
      };
      "org.kde.kdeconnect.nonplasma" = {
        exec = "";
        name = "KDE Connect Indicator";
        settings.NoDisplay = "true";
      };
      "org.kde.kdeconnect.app" = {
        exec = "";
        name = "KDE Connect";
        settings.NoDisplay = "true";
      };
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };

    home.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/persist/${config.home.homeDirectory}".directories = [".config/kdeconnect"];
    };
  };
}
