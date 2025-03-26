_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.droid.terminal;
in {
  options = {
    frostbite.droid.terminal = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    terminal = {
      colors = {
        background = "#000000";
        foreground = "#FFFFFF";
        cursor = "#FFFFFF";
      };
      font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF.ttf}";
    };
  };
}
