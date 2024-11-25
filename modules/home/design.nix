{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.design;
in {
  imports = [
    inputs.base16.homeManagerModule
  ];

  options = {
    design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  # TODO: Make this a service to dynamically switch themes
  config = lib.mkIf cfg.enable {
    scheme = "${inputs.tt-schemes}/base16/nord.yaml";
    stylix = {
      enable = true;

      base16Scheme = config.scheme;

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
	fish.enable = false;
      };
    };
  };
}
