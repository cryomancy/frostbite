scoped: {
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.kosei.gnome;

  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  nixos-gsettings-desktop-schemas = pkgs.gnome.nixos-gsettings-overrides.override {
    inherit (cfg) extraGSettingsOverrides extraGSettingsOverridePackages favoriteAppsOverride;
  };
in {
  options.kosei = {
    gnome = {
      enable = lib.mkEnableOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GNOME desktop manager.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xsession.extraInit = ''
      ${lib.concatMapStrings (p: ''
          if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
            export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
          fi

          if [ -d "${p}/lib/girepository-1.0" ]; then
            export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
          fi
        '')
        cfg.sessionPath}
    '';

    home = {
      sessionVariables = {
        GNOME_SESSION_DEBUG = lib.mkIf cfg.debug "1";
        NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
        NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
        XDG_DATA_DIRS = ["${mimeAppsList}/share"];
      };
    };

    services = {
      gnome-keyring.enable = true;
    };

    nixosConfig = {
      environment.pathsToLink = [
        "/share/nautilus-python/extensions"
        "/share"
      ];

      services = {
        accounts-daemon.enable = true;
        displayManager.sessionPackages = [pkgs.gnome-session.sessions];

        # Will this break something?
        udev.packages = [
          pkgs.mutter
        ];

        dleyna-renderer.enable = lib.mkDefault true;
        dleyna-server.enable = lib.mkDefault true;
        power-profiles-daemon.enable = lib.mkDefault true;

        libinput.enable = lib.mkDefault true;
      };
    };

    xdg = {
      mime.enable = true;
      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-gtk
        ];
        configPackages = lib.mkDefault [pkgs.gnome-session];
      };
    };

    home.packages = with pkgs; [
      gnome-shell
      adwaita-icon-theme
      gnome-backgrounds
      gnome-bluetooth
      gnome-color-manager
      gnome-control-center
      gnome-shell-extensions
      glib
      gnome-menus
      gtk3.out
      xdg-user-dirs
      xdg-user-dirs-gtk
      gnome-session
      gnome-shell
      baobab
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-console
      gnome-contacts
      gnome-maps
      gnome-system-monitor
      gnome-weather
      loupe
      nautilus
      gnome-connections
      simple-scan
      totem
      sound-theme-freedesktop
    ];
  };
}
