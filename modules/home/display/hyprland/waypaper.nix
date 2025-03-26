_: {
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.frostbite.display.hyprland.waypaper;
in {
  options = {
    frostbite.display.hyprland.waypaper = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.display.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".config/waypaper"];
        };
      };
      packages = with pkgs; [waypaper swww];
    };

    xdg.configFile."waypaper/config.ini".text = ''
      [Settings]
      language = en
      folder = ${inputs.assets}/wallpapers
      wallpaper = ${inputs.assets}/wallpapers/anime/a_waterfall_in_the_rain.jpg
      backend = swww
      monitors = All
      fill = Fill
      sort = name
      color = #ffffff
      subfolders = False
      number_of_columns = 3
      include_all_subfolders = True
      include_subfolders = True
      show_hidden = True
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
