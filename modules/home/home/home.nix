scoped: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.kosei.homeManagement;
in {
  options = {
    kosei.homeManagement = {
      enable = lib.mkOption {
        default = true;
        example = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".local/state/home-manager"];
        };
      };
      homeDirectory = "/home/${config.home.username}";
      stateVersion = "24.05";
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };

    home.sessionVariables = {
      XDG_RUNTIME_VARIABLES = "/run/user/$UID";
      EDITOR = "nvim";
    };

    programs = {
      home-manager.enable = true;
    };
  };
}
