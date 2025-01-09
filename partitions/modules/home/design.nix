{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.design;
in {
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
      autoEnable = true;

      targets = {
        bat.enable = true;
        btop.enable = true;
        firefox.enable = true;
        fzf.enable = true;
        # gtk.enable = true;
        hyprland.enable = true;
        hyprland.hyprlock.enable = true;
        hypraper.enable = true;
        kitty.enable = true;
        librewolf.enable = true;
        mangohud.enable = true;
        rofi.enable = true;
        waybar.enable = true;
        zellij.enable = true;
        #nixvim = {
        #  enable = true;
        #  plugin = "base16-nvim";
        #};
      };
    };
  };
}
