# Impermanent Btrfs layout w/ encryption
{drives, ...}: {
  disko.devices = {
    disk.main = {
      type = "disk";
      inherit (drives.root) device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            inherit (drives.esp) size;
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

          luks = {
            inherit (drives.root) size;
            label = "NixOS"; # Partition label
            content = {
              type = "luks";
              name = "root"; # Mapper name
              askPassword = true; # Ask to set the encryption password
              settings = {
                # The security implications of allowing discards
                # aren't really relevant to my use case.
                allowDiscards = true;
                # Improve SSD performance
                bypassWorkqueues = true;
              };
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "-LNixOS" # Filesystem label
                ];

                # Create the initial blank snapshot
                postCreateHook = ''
                  mount -o subvol=/ /dev/mapper/root /mnt
                  btrfs sub snap -r /mnt/@ /mnt/@-blank
                  umount /mnt
                '';

                subvolumes = let
                  commonOptions = [
                    "compress=zstd"
                    "noatime"
                    "nodiscard" # Prefer periodic TRIM
                  ];
                in {
                  # Root subvolume
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = commonOptions;
                  };

                  # Persistent data
                  "/@persist" = {
                    mountpoint = "/persist";
                    mountOptions =
                      commonOptions
                      ++ [
                        "nodev"
                        "nosuid"
                        "noexec"
                      ];
                  };

                  # User home directories
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions =
                      commonOptions
                      ++ [
                        "nodev"
                        "nosuid"
                      ];
                  };

                  # Nix data, including the store
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions =
                      commonOptions
                      ++ [
                        "nodev"
                        "nosuid"
                      ];
                  };

                  # System logs
                  "/@log" = {
                    mountpoint = "/var/log";
                    mountOptions =
                      commonOptions
                      ++ [
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
  };
}
