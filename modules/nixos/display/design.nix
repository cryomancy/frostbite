_: {
  config,
  lib,
  pkgs,
  inputs,
  users,
  ...
}: let
  cfg = config.frostbite.display.design;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options = {
    frostbite.display.design = {
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
          package = pkgs.nerd-fonts.jetbrains-mono;
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
        console.enable = true;
        grub.enable = true;
        gnome.enable = true;
        lightdm.enable = true;
        regreet.enable = true;
      };

      polarity = "dark";
    };
  };
}
