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
        default = config.frostbite.display.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".config/wpaperd"];
        };
      };
      packages = with pkgs; [wpaperd swww];
    };

    programs.wpaperd = {
      enable = true;
      settings = {
        any = {
          path = "${inputs.assets}" + "/wallpapers/anime/";
        };
      };
    };

    systemd.user.services.wpaperd = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hyprpaper";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
        X-Restart-Triggers =
          lib.mkIf (config.programs.wpaperd.settings != {})
          ["${config.xdg.configFile."wpaperd/wallpaper.toml".source}"];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.wpaperd}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
