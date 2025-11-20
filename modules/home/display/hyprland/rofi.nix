_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.display.hyprland.wofi;
in {
  options = {
    frostbite.display.hyprland.wofi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.display.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      settings = {
        width = 600;
        height = 350;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 40;
        gtk_dark = true;
      };
    };

    xdg.configFile."wofi/style.css".text = ''
      #  configuration{
      #    modi: "run,drun,window";
      #    lines: 5;
      #    cycle: false;
      #    font: "JetBrainsMono NF Bold 15";
      #    show-icons: true;
      #    icon-theme: "Papirus-dark";
      #    terminal: "kitty";
      #    drun-display-format: "{icon} {name}";
      #    location: 0;
      #    disable-history: true;
      #    hide-scrollbar: true;
      #    display-drun: " Apps ";
      #    display-run: " Run ";
      #    display-window: " Window ";
      #    sidebar-mode: true;
      #    sorting-method: "fzf";
      #  }
    '';
  };
}
