{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  inherit (vars.themes.everforest-dark-hard) base16Scheme;
  cfg = config.fuyuStyle;
in {
  options = {
    fuyuStyle = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      inherit base16Scheme;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };

      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
      };

      opacity = {
        applications = .7;
        popups = .7;
        terminal = .7;
      };

      polarity = "dark";

      targets = {
        rofi.enable = true;
        nixvim.enable = true;
        firefox.enable = false;
        gnome.enable = false;
      };
    };
  };
}
