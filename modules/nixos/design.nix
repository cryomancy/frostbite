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
    inputs.base16.nixosModule
  ];

  options = {
    fuyuNoKosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      image = "${inputs.walls}/anime/a_drawing_of_a_horse_carriage_on_a_bridge.png";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };

      fonts = {
        monospace = {
          package = with pkgs; [
            (nerdfonts.override {fonts = ["meslo-lg"];})
          ];
          name = "Nerd Fonts: Slashed zeros, customized version of Apple's Menlo";
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
        applications = .5;
        popups = .5;
        terminal = .5;
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
