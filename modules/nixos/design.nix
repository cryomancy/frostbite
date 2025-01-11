scoped: {
  config,
  lib,
  pkgs,
  inputs,
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
        example = "${inputs.assets}/wallpapers/theme.yaml";
      };
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = null;
        example = "${inputs.assets}/wallpapers/image.png";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    enable = true;

    base16Scheme = "${cfg.theme}";

    image = "${cfg.wallpaper}";

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
}
