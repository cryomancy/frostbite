_: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.frostbite.system.home;
in {
  options = {
    frostbite.system.home = {
      enable = lib.mkOption {
        default = true;
        example = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".local/state/home-manager"];
        };
      };
      homeDirectory = lib.mkForce "/home/${config.home.username}";
      stateVersion = "24.11";
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };

    home.sessionVariables = {
      XDG_RUNTIME_VARIABLES = "/run/user/$UID";
      # TODO: Base this off a user option?
      EDITOR = "nvim";
    };

    programs = {
      home-manager.enable = true;
    };
  };
}
