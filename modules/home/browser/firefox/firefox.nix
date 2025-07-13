_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.browser.firefox;
  userChrome = cfg.stylesheet;
  firefoxSettings = import ./_firefoxSettings.nix;
  inherit (firefoxSettings) settings policies;
in {
  options = {
    frostbite.browser.firefox = {
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

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles = {
        main = {
          id = 0;
          name = "main";
          inherit settings userChrome;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            darkreader
            keepassxc-browser
            musescore-downloader
            sidebery
            sponsorblock
            torrent-control
            ublock-origin
          ];

          search = {
            force = true;
            order = [
              "DuckDuckGo"
              "Google"
            ];
          };
        };
      };

      inherit policies;
    };
  };
}
