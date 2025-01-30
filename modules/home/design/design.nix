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
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = "${config.home.homeDirectory}/.local/state/wpaperd/wallpapers";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;

      image = "${inputs.assets}/wallpapers/anime/a_waterfall_in_the_rain.jpg";

      opacity = {
        applications = 0.85;
        desktop = 0.85;
        popups = 0.65;
        terminal = 0.65;
      };

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
