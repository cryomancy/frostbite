_: {
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.frostbite.display.design;
  users = lib.attrsets.attrNames config.frostbite.users.users;
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
      autoEnable = true;

      base16Scheme = "${cfg.theme}";

      # TODO: Check upstream, why does this have to be set for all users?
      image = "${inputs.assets}/wallpapers/dark/a_screen_shot_of_a_computer.jpg";

      cursor = {
        package = pkgs.bibata-cursors;
        size = 2;
        name = "Bibata-Modern-Ice";
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "Fira Code Nerd Font Mono";
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
