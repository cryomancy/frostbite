scoped: {
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    mkDefault
    mkEnableOption
    literalExpression
    ;

  cfg = config.kosei.gnome;
  serviceCfg = osConfig.services.gnome;

  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  defaultFavoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[]
  '';

  nixos-gsettings-desktop-schemas = pkgs.gnome.nixos-gsettings-overrides.override {
    inherit (cfg) extraGSettingsOverrides extraGSettingsOverridePackages favoriteAppsOverride;
  };

  notExcluded = pkg: mkDefault (!(lib.elem (lib.getName pkg) (map lib.getName config.environment.gnome.excludePackages)));
in {
  options.kosei = {
    services.gnome = {
      core-os-services.enable = mkEnableOption "essential services for GNOME3";
      core-shell.enable = mkEnableOption "GNOME Shell services";
      core-utilities.enable = mkEnableOption "GNOME core utilities";
    };

    gnome = {
      enable = mkEnableOption {
        type = types.bool;
        default = false;
        description = "Enable GNOME desktop manager.";
      };

      sessionPath = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExpression "[ pkgs.gpaste ]";
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GNOME Shell extensions or GSettings-conditional autostart.
        '';
      };

      favoriteAppsOverride = mkOption {
        internal = true;
        default = defaultFavoriteAppsOverride;
        type = types.lines;
        example = literalExpression ''
          '''
            [org.gnome.shell]
            favorite-apps=[ 'firefox.desktop', 'org.gnome.Calendar.desktop' ]
          '''
        '';
        description = "List of desktop files to put as favorite apps into pkgs.gnome-shell. These need to be installed somehow globally.";
      };

      extraGSettingsOverrides = mkOption {
        default = "";
        type = types.lines;
        description = "Additional gsettings overrides.";
      };

      extraGSettingsOverridePackages = mkOption {
        default = [];
        type = types.listOf types.path;
        description = "List of packages for which gsettings are overridden.";
      };

      debug = mkEnableOption "pkgs.gnome-session debug messages";
    };

    environment.gnome.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.totem ]";
      type = types.listOf types.package;
      description = "Which packages gnome should exclude from the default environment";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services = {
        gnome = {
          core-os-services.enable = true;
          core-shell.enable = true;
          core-utilities.enable = mkDefault true;
        };
      };

      # services.displayManager.sessionPackages = [pkgs.gnome-session.sessions];

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
        packages = cfg.sessionPath;
        sessionVariables = {
          GNOME_SESSION_DEBUG = lib.mkIf cfg.debug "1";
          NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
        };
      };
    })

    (lib.mkIf serviceCfg.core-os-services.enable {
      osConfig = {
        networking.networkmanager.enable = mkDefault true;
        programs.dconf.enable = true;
        security.polkit.enable = true;
        services = {
          accounts-daemon.enable = true;
          dleyna-renderer.enable = mkDefault true;
          dleyna-server.enable = mkDefault true;
          power-profiles-daemon.enable = mkDefault true;
          gnome = {
            at-spi2-core.enable = true;
            evolution-data-server.enable = true;
            gnome-keyring.enable = true;
            gnome-online-accounts.enable = mkDefault true;
            localsearch.enable = mkDefault true;
            tinysparql.enable = mkDefault true;
          };
          udisks2.enable = true;
          #upower.enable = osConfig.powerManagement.enable;
          libinput.enable = mkDefault true;
          xserver.updateDbusEnvironment = true;
        };
        environment.pathsToLink = [
          "/share"
        ];
      };

      xdg = {
        mime.enable = true;
        # icons.enable = true;
        portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
          ];
          configPackages = mkDefault [pkgs.gnome-session];
        };
      };

      home.packages = with pkgs; [
        sound-theme-freedesktop
      ];
    })

    (lib.mkIf serviceCfg.core-shell.enable {
      osConfig = {
        services = {
          xserver.desktopManager.gnome.sessionPath = [
            pkgs.gnome-shell
            pkgs.gnome-shell-extensions
          ];

          colord.enable = mkDefault true;
          gnome = {
            glib-networking.enable = true;
            gnome-browser-connector.enable = mkDefault true;
            gnome-initial-setup.enable = mkDefault true;
            gnome-remote-desktop.enable = mkDefault true;
            gnome-settings-daemon.enable = true;
            gnome-user-share.enable = mkDefault true;
            rygel.enable = mkDefault true;
          };
          gvfs.enable = true;
          orca.enable = notExcluded pkgs.orca;
          udev.packages = [
            pkgs.mutter
          ];
          avahi.enable = mkDefault true;
          geoclue2 = {
            enable = mkDefault true;
            enableDemoAgent = false;
            appConfig = {
              gnome-datetime-panel = {
                isAllowed = true;
                isSystem = true;
              };
              gnome-color-panel = {
                isAllowed = true;
                isSystem = true;
              };
              "org.  Shell" = {
                isAllowed = true;
                isSystem = true;
              };
            };
          };
        };
      };

      home.packages = [
        pkgs.gnome-shell
        pkgs.adwaita-icon-theme
        pkgs.gnome-backgrounds
        pkgs.gnome-bluetooth
        pkgs.gnome-color-manager
        pkgs.gnome-control-center
        pkgs.gnome-shell-extensions
        pkgs.glib
        pkgs.gnome-menus
        pkgs.gtk3.out
        pkgs.xdg-user-dirs
        pkgs.xdg-user-dirs-gtk
        pkgs.gnome-session
        pkgs.gnome-shell
      ];
    })

    (lib.mkIf serviceCfg.core-utilities.enable {
      home.packages = [
        pkgs.baobab
        pkgs.gnome-calculator
        pkgs.gnome-calendar
        pkgs.gnome-characters
        pkgs.gnome-clocks
        pkgs.gnome-console
        pkgs.gnome-contacts
        pkgs.gnome-maps
        pkgs.gnome-system-monitor
        pkgs.gnome-weather
        pkgs.loupe
        pkgs.nautilus
        pkgs.gnome-connections
        pkgs.simple-scan
        pkgs.totem
      ];

      osConfig = {
        services.gnome.sushi.enable = notExcluded pkgs.sushi;
        programs = {
          file-roller.enable = notExcluded pkgs.file-roller;
          gnome-disks.enable = notExcluded pkgs.gnome-disk-utility;
          seahorse.enable = notExcluded pkgs.seahorse;
          bash.vteIntegration = mkDefault true;
          zsh.vteIntegration = mkDefault true;
        };
        environment.pathsToLink = [
          "/share/nautilus-python/extensions"
        ];
      };

      home = {
        sessionVariables = {
          NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
          XDG_DATA_DIRS = ["${mimeAppsList}/share"];
        };
      };
    })
  ];
}
