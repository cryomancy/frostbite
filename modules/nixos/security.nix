scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.security;
in {
  options = {
    kosei.security = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      level = lib.mkOption {
        type = lib.types.ints.between 0 5;
        default = 2;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security = {
      sudo = {
        wheelNeedsPassword =
          if cfg.level > 3
          then true
          else false;
        execWheelOnly = (lib.mkIf (cfg.level > 3)) true;
        extraConfig = ''
          Defaults lecture = never
        '';
      };
      apparmor = {
        enable = true;
      };
      audit = {
        enable = (lib.mkIf (cfg.level > 1)) true;
      };
      auditd = {
        enable = (lib.mkIf (cfg.level > 1)) true;
      };
      # Enables authentication via Hyprlock
      # NOTE: Does this need to match a home option?
      pam.services.hyprlock = {};
      polkit = {
        enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      apparmor-bin-utils
      apparmor-profiles
      apparmor-parser
      apparmor-kernel-patches
      apparmor-pam
      apparmor-utils
      libapparmor
    ];

    services = {
      dbus.apparmor = "enabled";

      clamav = {
        daemon.enable = true;
        updater.enable = true;
      };

      fail2ban.enable =
        if (cfg.level > 1)
        then true
        else false;
    };
  };
}
