scoped: {
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.kosei.mako;
in {
  options = {
    kosei.mako = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      #persistence = lib.mkIf config.kosei.impermanence.enable {
      #  "/nix/persistent/home/${user}" = {
      #    directories = [".config/"];
      #  };
      #};
      packages = [pkgs.libnotify];
    };

    services.mako = {
      enable = true;

      anchor = "top-right";
      borderRadius = 5;
      borderSize = 2;
      padding = "20";
      defaultTimeout = 5000;
      layer = "top";
      height = 100;
      width = 300;
      format = "<b>%s</b>\\n%b";

      extraConfig = ''
        [urgency=low]
        default-timeout=3000

        [urgency=high]
        default-timeout=10000

        [mode=dnd]
        invisible=1
      '';
    };
  };
}
