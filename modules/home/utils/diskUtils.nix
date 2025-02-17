scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.diskUtils;
in {
  options = {
    kosei.diskUtils = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Disk and file management
      pciutils # PCI device listing
      usbutils # USB device listing
      du-dust # A tool to find disk usage by directories
    ];
  };
}
