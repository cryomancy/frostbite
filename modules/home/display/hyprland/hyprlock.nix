_: {
  config,
  inputs,
  lib,
  nixosConfig,
  user,
  ...
}: let
  cfg = config.frostbite.display.hyprland.hyprlock;
  isLaptop = nixosConfig.frostbite.security.useCase == "laptop";
  # from home-manager nixos/default.nix
  # home-manager.extraSpecialArgs.nixosConfig = config;
in {
  options = {
    frostbite.display.hyprland.hyprlock = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.display.hyprland.enable;
      };
    };
    nixosConfig.security.pam.services.hyprlock = lib.mkIf isLaptop {};
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        files = [".config/hpyr/hpyrlock.conf"];
      };
    };

    programs.hyprlock = {
      enable = true;

      extraConfig = ''
        background {
          monitor =
          path = ${inputs.assets}/anime/a_drawing_of_a_horse_carriage_on_a_bridge.png"
          blur_passes = 2
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
        }

        general {
          hide_cursor = true
          no_fade_in = false
          grace = 0
          disable_loading_bar = false
          ignore_empty_input = true
          fractional_scaling = 0
        }

        # Time
        label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%k:%M")"
          font_size = 115
          shadow_passes = 3
          position = 0, ${
          if isLaptop
          then "-25"
          else "-150"
        }
          halign = center
          valign = top
        }

        # Day
        label {
          monitor =
          text = cmd[update:1000] echo "- $(date +"%A, %B %d") -"
          font_size = 18
          shadow_passes = 3
          position = 0, ${
          if isLaptop
          then "-225"
          else "-350"
        }
          halign = center
          valign = top
        }


        # USER-BOX
        shape {
          monitor =
          size = 300, 50
          rounding = 15
          border_size = 0
          rotate = 0

          position = 0, ${
          if isLaptop
          then "120"
          else "270"
        }
          halign = center
          valign = bottom
        }

        # USER
        label {
          monitor =
          text =   $USER
          font_size = 15
          position = 0, ${
          if isLaptop
          then "131"
          else "281"
        }
          halign = center
          valign = bottom
        }

        input-field {
          monitor =
          size = 300, 50
          outline_thickness = 0
          rounding = 15
          dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.4 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true
          font_size = 14
          fade_on_empty = false
          placeholder_text = "Enter Password..."
          hide_input = false
          position = 0, ${
          if isLaptop
          then "50"
          else "200"
        }
          halign = center
          valign = bottom
        }
      '';
    };
  };
}
