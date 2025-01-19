scoped: {
  config,
  lib,
  pkgs,
  inputs,
  users,
  ...
}: let
  cfg = config.kosei.design;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options = {
    kosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      theme = lib.mkOption {
        type = lib.types.str;
        default = null;
        example = "${inputs.assets}/themes/theme.yaml";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;

      base16Scheme = "${cfg.theme}";
      image = /home/${builtins.elemAt users 0}/.local/state/wallpaperd/wallpapers;

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

      targets = {
        fish.enable = true;
        grub.enable = true;
        gnome.enable = false;
        lightdm.enable = false;
        regreet.enable = true;
      };

      polarity = "dark";
    };
  };
}
