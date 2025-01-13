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
      acme.acceptTerms = true;
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

    boot.kernel.sysctl = {
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      "kernel.sysrq" = 0;

      # Disable NMI watchdog
      "kernel.nmi_watchdog" = 0;

      # To hide any kernel messages from the console
      "kernel.printk" = "3 3 3 3";

      # Only swap when absolutely necessary
      "vm.swappiness" = "1";

      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };
  };
}
