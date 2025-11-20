_:
{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.frostbite.display.hyprland.waypaper;
in
{
  options = {
    frostbite.display.hyprland.waypaper = {
      enable = lib.mkOption {
        type = lib.types.bool;
        # default = config.frostbite.display.hyprland.enable;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [ ".config/waypaper" ];
        };
      };
      packages = [ pkgs.waypaper ];
    };

    services.swww.enable = true;

    xdg.configFile."waypaper/config.ini" = {
      enable = true;
      force = true;
      text = ''
        [Settings]
        language = en
        folder = ${inputs.assets}/wallpapers
        backend = swww
        monitors = All
        fill = Fill
        sort = name
        color = #ffffff
        subfolders = True
        all_subfolders = True
        show_hidden = True
        show_gifs_only = False
        show_path_in_tooltip = True
        number_of_columns = 3
        use_xdg_state = True
        swww_transition_type = any
        swww_transition_step = 90
        swww_transition_angle = 0
        swww_transition_duration = 2
        swww_transition_fps = 60
        mpvpaper_sound = False
        mpvpaper_options =
        post_command =
      '';
    };

    xdg.stateFile."waypaper/state.ini" = {
      enable = true;
      force = true;
      text = ''
        [State]
        folder = ${inputs.assets}/wallpapers
        monitors = All
        wallpaper =
      '';
    };

    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=${(lib.getExe pkgs.waypaper)} --restore
    '';
  };
}
