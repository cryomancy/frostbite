{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.browser;
in {
  options = {
    fuyuNoKosei.browser = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      chrome.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      chromium.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      firefox.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      terminal.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      librewolf.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.lists.optionals cfg.chrome.enable [pkgs.google-chrome]
      ++ lib.lists.optionals cfg.terminal.enable
      [
        pkgs.w3m
        pkgs.lynx
      ];

    # TODO: Add logic to enable both at the same time OR verify they both cannot be enabled
    programs.firefox = lib.mkIf (cfg.firefox.enable || cfg.librewolf.enable) {
      enable = true;
      package =
        if cfg.librewolf.enable
        then pkgs.librewolf
        else pkgs.firefox;

      profiles = {
        default = {
          id = 0;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.urlbar.quickactions.enabled" = false;
            "browser.urlbar.quickactions.showPrefs" = false;
            "browser.urlbar.shortcuts.quickactions" = false;
            "browser.urlbar.suggest.quickactions" = false;
            "browser.startup.homepage" = "about:blank";
            # Yubikey
            "security.webauth.u2f" = true;
            "security.webauth.webauthn" = true;
            "security.webauth.webauthn_enable_softtoken" = true;
            "security.webauth.webauthn_enable_usbtoken" = true;
            "distribution.searchplugins.defaultLocale" = "en-US";
          };
          userChrome = ''
                        #navigator-toolbox {
                          --uc-bm-padding: 4px;
                          --uc-bm-height: calc(20px + 2 * var(--uc-bm-padding));
                          --uc-navbar-height: -40px;
                          --uc-autohide-toolbar-delay: 600ms;
                        }

                        :root[uidensity="compact"] #navigator-toolbox {
                          --uc-navbar-height: -34px;
                        }
                        :root[uidensity="touch"] #navigator-toolbox {
                          --uc-bm-padding: 6px;
                        }

                        :root[sessionrestored] #nav-bar,
                        :root[sessionrestored] #PersonalToolbar {
                          background-image: linear-gradient(var(--toolbar-bgcolor), var(--toolbar-bgcolor)), var(--lwt-additional-images, var(--toolbar-bgimage)) !important;
                          background-position: top, var(--lwt-background-alignment);
                          background-position-y: calc(0px - var(--tab-min-height) - 2 * var(--tab-block-margin, 0px));
                          background-repeat: repeat, var(--lwt-background-tiling);
                          transform: rotateX(90deg);
                          transform-origin: top;
                          transition: transform 135ms linear var(--uc-autohide-toolbar-delay) !important;
                          z-index: 2;
                        }

                        :root[sessionrestored] #PersonalToolbar {
                          z-index: 1;
                          background-position-y: calc(0px - var(--tab-min-height) - 2 * var(--tab-block-margin, 0px) + var(--uc-navbar-height));
                        }

                        :root[lwtheme-image] #nav-bar,
                        :root[lwtheme-image] #PersonalToolbar {
                          background-image: linear-gradient(var(--toolbar-bgcolor), var(--toolbar-bgcolor)), var(--lwt-header-image), var(--lwt-additional-images, var(--toolbar-bgimage)) !important;
                        }

                        #nav-bar[customizing], #PersonalToolbar[customizing] {
                          transform: none !important;
                        }

                        #navigator-toolbox > #PersonalToolbar {
                          transform-origin: 0px var(--uc-navbar-height);
                          position: relative;
                        }

                        :root[sessionrestored]:not([customizing]) #navigator-toolbox {
                          margin-bottom: calc(-1px - var(--uc-bm-height) + var(--uc-navbar-height));
                        }

                        :root[sizemode="fullscreen"] #PersonalToolbar,
                        #PersonalToolbar[collapsed="true"] {
                          min-height: initial !important;
                          max-height: initial !important;
                          visibility: hidden !important;
                        }
                        #PersonalToolbar[collapsed="true"] #PlacesToolbarItems > *,
                        :root[sizemode="fullscreen"] #PersonalToolbar #PlacesToolbarItems > * {
                          visibility: hidden !important;
                        }

                        #navigator-toolbox {
                          pointer-events: none;
                          border-bottom: none !important;
                        }
                        #PersonalToolbar {
                          border-bottom: 1px solid var(--chrome-content-separator-color);
                        }
                        #navigator-toolbox > * {
                          pointer-events: auto;
                        }

                        #sidebar-box {
                          position: relative;
                        }

                        .tabbrowser-tab[selected] {
                          z-index: 3 !important;
                        }

                        #nav-bar:focus-within + #PersonalToolbar,
                        #navigator-toolbox > #nav-bar:focus-within {
                          transition-delay: 100ms !important;
                          transform: rotateX(0);
                        }

                        #navigator-toolbox:hover > .browser-toolbar {
                          transition-delay: 100ms !important;
                          transform: rotateX(0);
                        }

                        #navigator-toolbox > div {
                          display: contents;
                        }
                        :where(#titlebar, #tab-notification-deck, .global-notificationbox) {
                          -moz-box-ordinal-group: 0;
                        }
                        :root[BookmarksToolbarOverlapsBrowser] #navigator-toolbox-background {
                          margin-bottom: 0 !important;
                          z-index: auto !important;
                        }

                        #alltabs-button {
                          display: none;
                        }

                        .titlebar-button {
                          --uc-caption-background: var(--uc-caption-color);
                          opacity: 0.6;
                          --uc-caption-color: rgb(252, 185, 15);
                          background: transparent !important;
                          padding-inline: 10px !important;
                          transition: opacity 0.2s ease;
                        }

                        .titlebar-min {
                          opacity: 0.5;
                          --uc-caption-color: rgb(36, 209, 49);
                        }

                        .titlebar-close {
                          opacity: 0.7;
                          --uc-caption-color: rgb(250, 55, 55);
                          padding-right: 18px !important;
                        }

                        .titlebar-button:hover {
                          opacity: 1;
                        }

                        .titlebar-button > .toolbarbutton-icon {
                          list-style-image: none;
                          border-radius: 10px;
                          background: var(--uc-caption-background, currentColor) !important;
                        }

                        .browserStack > browser {
                          margin: 0px 4px 4px 4px !important;
                          border-radius: 8px !important;
                        }

                        findbar {
                          border-radius: 8px !important;
                          z-index: 2;
                          margin: 0 4px 4px !important;
                        }

                        #tabbrowser-tabpanels {
                          background-color: transparent !important;
                        }

                        #sidebar-box {
                          margin-left: 4px !important;
                          margin-bottom: 4px !important;
                          border-radius: var(--general-border-radius) !important;
                          border-color: transparent;
                          background-color: var(--auto-general-color) !important;
                        }

                        #browser {
                          --sidebar-border-color: transparent !important;
                        }

                        .browserContainer,
                        .browserStack,
                        .browserSidebarContainer,
                        #browser,
                        #appcontent {
                          background-color: var(--auto-accent-color) !important;
                        }

                        #navigator-toolbox,
                        #navigator-toolbox-background {
                          border-color: var(--auto-accent-color) !important;
                          background-color: var(--auto-accent-color) !important;
                        }

                        #TabsToolbar {
                          margin: 4px 4px 0px 4px !important;
                          border-radius: var(--general-border-radius) !important;
                          background-color: var(--auto-general-color) !important;
                        }

                        .browser-toolbar:not(.titlebar-color) {
                          margin: 4px 4px 0px 4px !important;
                          border-radius: var(--general-border-radius) !important;
                          background-color: var(--auto-general-color) !important;
                          box-shadow: 4px;
                        }

                        .tab-background:is([selected], [multiselected]) {
                          background-color: var(--auto-accent-color) !important;
                        }

                        @media (prefers-color-scheme: dark) {
                          :root {
                            --auto-accent-color: color-mix(in srgb, var(--auto-general-color) 86%, white);
                          }
                        }

                        @media (prefers-color-scheme: light) {
                          :root {
                            --auto-accent-color: color-mix(in srgb, var(--auto-general-color) 86%, black);
                          }
                        }

                        :root {
                          --tab-selected-bgcolor: var(--auto-accent-color) !important;
                          --lwt-selected-tab-background-color: var(--auto-accent-color) !important;
                          --toolbar-field-background-color: var(--auto-accent-color) !important;
                          --toolbar-field-focus-background-color: var(--auto-accent-color) !important;
                          --toolbar-field-color: var(--lwt-text-color) !important;
                          --toolbar-field-focus-color: var(--lwt-text-color) !important;
                        }

                        #tabbrowser-tabs {
                          --lwt-tab-line-color: var(--auto-accent-color) !important;
                        }
                        #urlbar:not([focused]) #urlbar-input, /* ID for Firefox 70 */
            #urlbar:not([focused]) .urlbar-input{ text-align: center !important; }
            #urlbar:is([focused]) .urlbar-input{ text-align: center !important; }


          '';
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            dark-mode-website-switcher
          ];
          containers = {
            development = {
              id = 1;
            };
            personal = {
              id = 2;
            };
            gaming = {
              id = 3;
            };
          };
          containersForce = true;
          search = {
            force = true;
            order = [
              "DuckDuckGo"
              "Google"
            ];
          };
        };

        work = {
          id = 1;
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
	    dark-mode-website-switcher
          ];
          containersForce = true;
          search = {
            force = true;
            order = [
              "Google"
              "DuckDuckGo"
            ];
          };
        };
      };

      policies = {
        DisableAccounts = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisablePocket = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OverrideFirstRunPage = true;
        OverridePostUpdatePage = true;
      };
    };
  };
}
