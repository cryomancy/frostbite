scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.design;
in {
  options = {
    kosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packeges = with pkgs; [
      swww
    ];

    stylix = {
      enable = true;
      autoEnable = true;

      targets = {
        bat.enable = true;
        btop.enable = true;
        firefox.enable = true;
        fzf.enable = true;
        gtk.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
        kitty.enable = true;
        librewolf.enable = true;
        mangohud.enable = true;
        rofi.enable = true;
        waybar.enable = true;
        zellij.enable = true;
      };
    };
  };
}
