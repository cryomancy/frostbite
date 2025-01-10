scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.homeManagement;
  dir = "${config.home.homeDirectory}";
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
      homeDirectory = "/home/${config.home.username}";
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
      EDITOR = "nvim";
    };

    programs = {
      home-manager.enable = true;
    };
  };
}
