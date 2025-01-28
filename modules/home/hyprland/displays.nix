scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.displays;
in {
  options = {
    kosei.displays = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.monitors = [(builtins.readFile "${config.home.homeDirectory}/.config/hypr/workspaces.conf")];

    home.packages = with pkgs; [nwg-displays];

    #xdg.configFile."hypr/workspaces.conf".text = ''
    #
    #'';

    systemd.user.services.displays = {
      Unit = {
        description = "nwg-display daemon";
      };

      Install = {
        WantedBy = ["graphical.target"];
      };
      script = '''';
    };
  };
}
