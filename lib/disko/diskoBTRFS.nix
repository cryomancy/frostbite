# Impermanent Btrfs layout w/o encryption
_: {drive ? throw "Pass the device to be partitioned to this function"}: {
  disko.devices = {
    disk.main = {
      inherit drive;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            label = "ESP"; # Partition label
            content = {
              type = "filesystem";
              format = "vfat";
              extraArgs = ["-nESP"]; # Filesystem label
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "nodev"
                "nosuid"
                "noexec"
                "umask=0077"
              ];
            };
          };

          root = {
            size = "100%FREE";
            label = "NixOS";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-LNixOS" # Filesystem label
              ];

              # Create the initial blank snapshot
              postCreateHook = ''
                mount -o subvol=/ /dev/disk/by-label/NixOS /mnt
                btrfs sub snap -r /mnt/@ /mnt/@-blank
                umount /mnt
              '';

              subvolumes = {
                # Root subvolume
                "/@" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                # Persistent data
                "/@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "nodev"
                    "nosuid"
                    "noexec"
                  ];
                };

                # User home directories
                "/@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "nodev"
                    "nosuid"
                  ];
                };

                # Nix data, including the store
                "/@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "nodev"
                    "nosuid"
                  ];
                };

                # System logs
                "/@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "nodev"
                    "nosuid"
                    "noexec"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
