_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.display.hyprland.mako;
in
{
  options = {
    frostbite.display.hyprland.mako = {
      enable = lib.mkOption {
        type = lib.types.bool;
        # default = config.frostbite.display.hyprland.enable;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      #persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      #  "/nix/persistent/home/${user}" = {
      #    directories = [".config/"];
      #  };
      #};
      packages = [ pkgs.libnotify ];
    };

    services.mako = {
      enable = true;

      settings = {
        width = 420;
        height = 110;
        padding = "10";
        margin = "10";
        border-size = 2;
        border-radius = 0;

        anchor = "top-right";
        layer = "overlay";

        default-timeout = 5000;
        ignore-timeout = false;
        max-visible = 5;
        sort = "-time";

        group-by = "app-name";

        actions = true;

        format = "<b>%s</b>\\n%b";
        markup = true;
      };

      # settings = ''
      #  [urgency=low]
      #  default-timeout=3000
      #
      #  [urgency=high]
      #  default-timeout=10000
      #
      #  [mode=dnd]
      #  invisible=1
      #'';
    };
  };
}
