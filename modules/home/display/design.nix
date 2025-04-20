_: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.frostbite.display.design;
in {
  options = {
    frostbite.display.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [".config/stylix"];
      };
    };

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
        #hyprlock.enable = true;
        hyprpaper.enable = false;
        kitty.enable = true;
        librewolf.enable = true;
        mangohud.enable = true;
        mako.enable = true;
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
