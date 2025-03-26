_: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  # NOTE: Only configured for BTRFS with or without LUKS
  options = {
    kosei.impermanence = {
      enable = lib.mkEnableOption "impermanence";
      device = lib.mkOption {
        type = lib.types.path;
        default = null;
        description = ''
          Exact path of device containing BTRFS root file system
        '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = config.kosei.secrets.enable;
        message = "Kosei's secrets module must be enabled for this impermanence config";
      }
    ];

    #fileSystems."/persist".neededForBoot = true;
    environment.persistence =
      if !cfg.enable
      then {}
      else {
        "persist" = {
          # Hide these mounts from the sidebar of file managers
          hideMounts = true;

          directories = lib.lists.concatLists [
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

    boot.initrd.postResumeCommands =
      lib.strings.optionalString cfg.enable
      (lib.mkAfter
        ''
          mkdir -p /btrfs_tmp
          mount /dev/disk/by-label/NixOS /btrfs_tmp

          if [[ -e /btrfs_tmp /root ]]; then
           mkdir -p /btrfs_tmp/old_roots
           timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
           mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolumes() {
           IFS=$'\n'
           for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolumes "/btrfs_tmp/$i"
           done
           btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
           delete_subvolumes "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '');
  };
}
