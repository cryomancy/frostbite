{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.fuyuNoKosei.design;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options = {
    fuyuNoKosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      scheme = lib.mkOption {
        type = lib.types.str;
        default = "nord";
      };
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = ./anime/a_drawing_of_a_horse_carriage_on_a_bridge.png;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = let
      assets = builtins.fetchTree {
        type = "github";
        owner = "TahlonBrahic";
        repo = "assets";
      };
    in {
      enable = true;

      base16Scheme = "${assets}/themes/${cfg.scheme}.yaml";

      image = "${assets}/wallpapers/${cfg.wallpaper}";

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
        applications = .1;
        popups = .1;
        terminal = .1;
      };

      targets = {
        grub.enable = false;
        gnome.enable = false;
        lightdm.enable = false;
      };

      polarity = "dark";
    };
  };
}
