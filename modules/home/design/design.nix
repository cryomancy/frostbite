scoped: {
  config,
  inputs,
  lib,
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
    stylix = {
      enable = true;
      autoEnable = false;

      opacity = {
        applications = 0.85;
        desktop = 0.85;
        popups = 0.65;
        terminal = 0.65;
      };

      targets = {
        bat.enable = true;
        btop.enable = true;
        emacs.enable = true;
        firefox.enable = true;
        fish.enable = true;
        fzf.enable = true;
        gtk.enable = true;
        ghostty.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
        kitty.enable = true;
        librewolf.enable = true;
        mangohud.enable = true;
        rofi.enable = true;
        vesktop.enable = true;
        vim.enable = true;
        waybar.enable = true;
        wofi.enable = true;
        zellij.enable = true;
      };
    };
  };
}
