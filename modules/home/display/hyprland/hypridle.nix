_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.display.hyprland.hypridle;
in {
  options = {
    frostbite.display.hyprland.hypridle = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.display.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 350;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
    systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
  };
}
