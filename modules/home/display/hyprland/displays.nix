_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.display.hyprland.displays;
in {
  options = {
    frostbite.display.hyprland.displays = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.frostbite.display.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.monitor = ["${config.xdg.configFile."hypr/workspaces.conf".text}"];

    home.packages = with pkgs; [nwg-displays];

    xdg.configFile."hypr/workspaces.conf".text = "monitor = , preferred, auto, 1";

    systemd.user.services.displays = {
      Unit = {
        description = "nwg-display daemon";
      };

      Install = {
        WantedBy = ["graphical.target"];
      };
    };
  };
}
