scoped: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options = {
    kosei.impermanence = {
      enable = lib.mkEnableOption "impermanence";
      root = lib.mkOption;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = {
      "/nix/persistent" = {
        # Hide these mount from the sidebar of file managers
        hideMounts = true;

        directories = [
          "/home"
          "/root"
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/sops-nix"
          "/etc/NetworkManager/system-connections"
        ];

        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
        ];
      };
    };

    # TODO: Absolutely make this an option with parameters before enabling
    boot.initrd.postResumeCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };
}
