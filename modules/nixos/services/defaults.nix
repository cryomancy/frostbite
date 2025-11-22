_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.services.defaults;
in
{
  options = {
    frostbite.services.defaults = {
      enable = lib.mkEnableOption "defaultServices";
    };
  };

  config = lib.mkIf cfg.enable {
    security = {
      pam.services.swaylock = { };
      rtkit.enable = true;
    };

    services = {
      earlyoom = {
        enable = true;
        enableNotifications = true;
      };

      gvfs.enable = true;
      tumbler.enable = true;
      dbus.enable = true;
      upower.enable = true;
      openssh.enable = true;
      libinput.enable = true;
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # For proper XDG desktop integration
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
