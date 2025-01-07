{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.fuyuNoKosei.design;
in {
  imports = [
    inputs.assets
  ];

  options = {
    fuyuNoKosei.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  # TODO: Make this a service to dynamically switch themes
  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
      }
    ];

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
        hypaper.enable = true;
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
