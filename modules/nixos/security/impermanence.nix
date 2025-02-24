scoped: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  # NOTE: Only configured for BTRFS with or without LUKS
  options = {
    kosei.impermanence = {
      enable = lib.mkEnableOption "impermanence";
      root = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = ''
          Exact path of device containing BTRFS root file system
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [inputs.impermanence.nixosModules.impermanence];

    environment.persistence = {
      "/nix/persistent" = {
        # Hide these mount from the sidebar of file managers
        hideMounts = true;

        directories = [
          "/home"
          "/root"
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd"
          "/var/lib/sops-nix"
          "/etc/NetworkManager/system-connection"
        ];

        files = [
          "/etc/passwd"
          "/etc/group"
          "/etc/shadow"
          "/etc/gshadow"
          "/etc/subuid"
          "/etc/subgid"
          "/etc/machine-id"
        ];
      };
    };

    #boot.initrd.postResumeCommands = lib.mkAfter ''
    #  mkdir -p /mnt/impermanence
    #  mount ${cfg.root} /mnt/impermanence
    #
    #  if [[ -e ${cfg.root} ]]; then
    #      mkdir -p /mnt/impermanence/old_roots
    #      timestamp=$(date --date="@$(stat -c %Y /mnt/impermanence)" "+%Y-%m-%-d_%H:%M:%S")
    #      mv /mnt/impermanence "/mnt/impermanence/$timestamp"
    #  fi
    #
    #  delete_subvolume_recursively() {
    #      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
    #          delete_subvolume_recursively "/btrfs_tmp/$i"
    #      done
    #      btrfs subvolume delete "$1"
    #  }
    #
    #  for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
    #      delete_subvolume_recursively "$i"
    #  done
    #
    #  btrfs subvolume create /mnt/impermanence/root
    #  umount /btrfs_tmp
    #'';
  };
}
