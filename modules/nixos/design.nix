{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.design;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.base16.nixosModule
  ];

  options = {
    design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    scheme = "${inputs.tt-schemes}/base16/nord.yaml";
    stylix = {
      enable = true;

      image = "${inputs.walls}/anime/a_drawing_of_a_horse_carriage_on_a_bridge.png";

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
        applications = 4.0;
        popups = 5.0;
        terminal = 2.0;
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
