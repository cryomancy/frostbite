scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.android-terminal;
in {
  options = {
    kosei.android-terminal = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
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
