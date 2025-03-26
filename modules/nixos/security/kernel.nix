_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.security.kernel;
  secOpts = config.kosei.security.settings;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    kosei.security.kernel = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = lib.attrsets.optionalAttrs (!isOpen) {
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
