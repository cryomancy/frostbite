_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.utils.disk;
in
{
  options = {
    frostbite.utils.disk = {
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
      # btrfs-list # Get a nice tree-style view of your btrfs subvolumes/snapshot
      btrfs-assistant # GUI management tool to make managing a Btrfs filesystem easier
      udiskie # manage removable media
      ntfs3g # ntfs support
      exfat # exFAT support
    ];
  };
}
