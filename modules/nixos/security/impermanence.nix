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
    kosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = {
      "/nix/persistent" = {
        # Hide these mount from the sidebar of file managers
        hideMounts = true;

        # Folders you want to map
        directories = [
          "/etc/NetworkManager/system-connections"
          "/home"
          "/root"
          "/var"
        ];

        # Files you want to map
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
        ];

        users.tahlon = {
          directories = [
            # Personal files
            "Desktop"
            "Documents"
            "Downloads"
            "Music"
            "Pictures"
            "Videos"

            # Config folders
            ".cache"
            ".config"
            ".gnupg"
            ".local"
            ".ssh"
          ];
          files = [];
        };
      };
    };
  };
}
