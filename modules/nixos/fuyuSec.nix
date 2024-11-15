{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuSec;
in {
  options = {
    fuyuSec = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security = {
      sudo.wheelNeedsPassword = false;
      apparmor = {
        enable = true;
      };
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

      fail2ban.enable = true;
    };
  };
}
