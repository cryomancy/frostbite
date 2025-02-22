scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.systemUtils;
in {
  options = {
    kosei.systemUtils = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # System utilities and hardware monitoring
      cifs-utils # CIFS (SMB) file system utilities
      rsync # Remote file and directory synchronization
      sysstat # System performance tools (e.g., iostat, mpstat)
      iotop # Display I/O usage by processes
      iftop # Display bandwidth usage on an interface
      btop # Resource monitor (similar to top)
      nmon # Performance monitoring tool
      sysbench # Benchmarking tool
      lm_sensors # Hardware monitoring (temperature, fan speed)
      psmisc # Utilities like `fuser` and `pstree`
      dmidecode # Dump system DMI (SMBIOS) data
      parted # A partitioning tool
      ethtool # Ethernet device settings and diagnostics
      acpilight # ACPI backlight control
    ];
  };
}
