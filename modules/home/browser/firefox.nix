scoped: {
  config,
  inputs,
  pkgs,
  lib,
  system,
  ...
}: let
  cfg = config.kosei.browser.firefox;
  inherit (inputs.nur.legacyPackages.${system}.repos.rycee) firefox-addons;
  userChrome = cfg.stylesheet;
  settings = {
    "app.normandy.api_url" = "";
    "app.normandy.enabled" = false;
    "app.shield.optoutstudies.enabled" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.bookmarks.addedImportButton" = false;
    "browser.cache.disk.enable" = false;
    "browser.cache.memory.capacity" = -1;
    "browser.cache.memory.enable" = true;
    "browser.contentblocking.report.lockwise.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.download.useDownloadDir" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.ping-centre.telemetry" = false;
    "browser.preferences.defaultPerformanceSettings.enabled" = false;
    "browser.search.suggest.enabled" = false;
    "browser.startup.homepage" = "about:blank";
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.urlbar.quickactions.enabled" = false;
    "browser.urlbar.quickactions.showPrefs" = false;
    "browser.urlbar.shortcuts.bookmarks" = false;
    "browser.urlbar.shortcuts.history" = false;
    "browser.urlbar.shortcuts.tabs" = false;
    "browser.urlbar.suggest.bookmark" = false;
    "browser.urlbar.suggest.engines" = false;
    "browser.urlbar.suggest.history" = true;
    "browser.urlbar.suggest.openpage" = false;
    "browser.urlbar.suggest.searches" = false;
    "browser.urlbar.suggest.topsites" = false;
    "browser.uitour.enabled" = false;
    "devtools.onboarding.telemetry.logged" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "dom.security.https_first" = true;
    "extensions.abuseReport.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "general.smoothScroll" = true;
    "general.smoothScroll.lines.durationMaxMS" = 125;
    "general.smoothScroll.lines.durationMinMS" = 125;
    "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
    "general.smoothScroll.mouseWheel.durationMinMS" = 100;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "general.smoothScroll.other.durationMaxMS" = 125;
    "general.smoothScroll.other.durationMinMS" = 125;
    "general.smoothScroll.pages.durationMaxMS" = 125;
    "general.smoothScroll.pages.durationMinMS" = 125;
    "identity.fxaccounts.commands.enabled" = false;
    "identity.fxaccounts.enabled" = false;
    "identity.fxaccounts.pairing.enabled" = false;
    "identity.fxaccounts.toolbar.enabled" = false;
    "middlemouse.paste" = false;
    "mousewheel.min_line_scroll_amount" = 30;
    "mousewheel.system_scroll_override_on_root_content.enabled" = true;
    "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
    "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
    "network.dns.disableIPv6" = true;
    "network.dns.disablePrefetch" = true;
    "network.prefetch-next" = false;
    "network.proxy.socks_remote_dns" = true;
    "permissions.default.camera" = 0;
    "permissions.default.desktop-notification" = 2;
    "permissions.default.geo" = 0;
    "permissions.default.microphone" = 0;
    "permissions.default.xr" = 2;
    "pdfjs.enableScripting" = false;
    "security.ssl.require_safe_negotiation" = true;
    "signon.autofillForms" = false;
    "signon.rememberSignons" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "toolkit.scrollbox.horizontalScrollDistance" = 6;
    "toolkit.scrollbox.verticalScrollDistance" = 2;
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.unified" = false;
  };
in {
  options = {
    kosei.browser = {
      firefox = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        stylesheet = lib.mkOption {
          type = lib.types.str;
          default = builtins.readFile ./_assets/twilly.css;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles = {
        main = {
          id = 0;
          name = "main";
          inherit settings userChrome;
          extensions = with firefox-addons; [
            ublock-origin
            simple-tab-groups
            darkreader
            keepassxc-browser
            musescore-downloader
            sponsorblock
            torrent-control
          ];

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
          name = "work";
          inherit settings userChrome;
          extensions.packages = with firefox-addons; [
            ublock-origin
            simple-tab-groups
            darkreader
            keepassxc-browser
          ];
          search = {
            force = true;
            order = [
              "Google"
              "DuckDuckGo"
            ];
          };
        };

        i2pd = {
          # TODO: add a policy to 'use this proxy for HTTPS' 127.0.0.1:4444 and 4447
          id = 2;
          name = "i2pd";
          search = {
            force = true;
            order = [
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
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        HardwareAcceleration = true;
        NoDefaultBookmarks = true;
        OverrideFirstRunPage = true;
        OverridePostUpdatePage = true;
        toolkit.legacyUserProfileCustomizations.stylesheet = true;
      };
    };
  };
}
