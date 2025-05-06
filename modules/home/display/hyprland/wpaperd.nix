_: {
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.frostbite.display.hyprland.wpaperd;
in {
  options = {
    frostbite.display.hyprland.wpaperd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  # NOTE: THIS IS NOT CURRENTLY STABLE / IMPLEMENTED AS IT SEEMS TO BE TO FOCUSED ON STATE
  # AND SHELL SCRIPTS WHICH DOES NOT PLAY WELL IN THE NIX ENVIRONMENT

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".config/wpaperd"];
        };
      };
    };

    programs.wpaperd = {
      enable = true;
      settings = {
        any = {
          path = "${inputs.assets}" + "/wallpapers/anime/";
        };
      };
    };

    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=${(lib.getExe pkgs.wpaperd)} -d
    '';
  };
}
