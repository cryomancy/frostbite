_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.display.hyprland.displays;
in
{
  options = {
    frostbite.display.hyprland.displays = {
      enable = lib.mkOption {
        type = lib.types.bool;
        # default = config.frostbite.display.hyprland.enable;
        default = false;
      };
      config = lib.mkOption {
        type = lib.types.str;
        default = "monitor = , preferred, auto, 1";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.monitor = [
      "${config.xdg.configFile."hypr/workspaces.conf".text}"
    ];

    home.packages = with pkgs; [ nwg-displays ];

    xdg.configFile."hypr/workspaces.conf".text = cfg.config;

    systemd.user.services.displays = {
      Unit = {
        description = "nwg-display daemon";
      };

      Install = {
        WantedBy = [ "graphical.target" ];
      };
    };
  };
}
