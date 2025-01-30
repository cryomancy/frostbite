scoped: {
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.waypaper;
in {
  options = {
    kosei.waypaper = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.monitor = ["${config.xdg.configFile."waypaper/config.ini".text}"];

    home.packages = with pkgs; [waypaper swww];

    xdg.configFile."waypaper/config.ini".text = ''
      [Settings]
      language = en
      folder = ${inputs.assets + ./wallpapers}
      wallpaper = ${inputs.assets + ./wallpapers/anime/a_waterfall_in_the_rain.jpg}
      backend = swww
      monitors = All
      fill = Fill
      sort = name
      color = #ffffff
      subfolders = False
      number_of_columns = 3
      post_command =
      show_hidden = False
      show_gifs_only = False
      swww_transition_type = any
      swww_transition_step = 90
      swww_transition_angle = 0
      swww_transition_duration = 2
      swww_transition_fps = 60
      use_xdg_state = False
    '';
  };
}
