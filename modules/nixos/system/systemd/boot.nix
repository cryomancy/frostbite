scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.boot;
in {
  options.kosei.boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    quiet = lib.mkEnableOption "quiet boot mode";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # TODO: make a post on the difference between these
      # and why this is scoped
      kernelParams = (lib.mkIf cfg.quiet) [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = (lib.mkIf cfg.quiet) 0;
      initrd = {
        systemd.enable = true;
        verbose =
          if cfg.quiet
          then false
          else true;
      };
      loader = {
        grub = lib.mkDefault {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
          useOSProber = true;
        };
      };
    };
  };
}
