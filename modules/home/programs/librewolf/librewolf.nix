_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.browser.librewolf;
  userChrome = cfg.stylesheet;
  librewolfSettings = import ./_librewolfSettings.nix;
  inherit (librewolfSettings) settings policies;
in
{
  options = {
    frostbite.browser.librewolf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      stylesheet = lib.mkOption {
        type = lib.types.str;
        default = builtins.readFile ./_assets/twilly.css;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;

      profiles = {
        main = {
          id = 0;
          name = "main";
          inherit settings userChrome;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            darkreader
            # keepassxc-browser
            musescore-downloader
            sidebery
            sponsorblock
            ublock-origin
          ];

          search = {
            force = true;
            order = [
              "ddg"
            ];
          };
        };
      };

      inherit policies;
    };
  };
}
