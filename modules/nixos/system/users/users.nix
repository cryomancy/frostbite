_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.users;
in {
  options = {
    frostbite.users = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          If enabled, users will be managed by Frostbite and it's options.
        '';
      };

      accounts = lib.mkOption {
        default = {};
        type = with lib.types; listOf str;
        description = ''
          Additional user accounts to be created automatically by the system.
          Password is either set through the global initalPassword option below,
          the submodule's globalIntialPassword option, or with sops-nix;
        '';
      };

      globalIntialPassword = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = ''
          A password that will be set as the initial password for all new users.
          This is used if the secrets module does not set passwords.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sysusers.enable = false; # Conflicts with sops-nix
    services.userborn.enable = true;

    users = {
      mutableUsers = lib.mkDefault (
        if config.frostbite.security.secrets.enable
        then false
        else true
      );

      users =
        lib.genAttrs cfg.accounts
        (user: {
          extraGroups = lib.lists.concatLists [
            (lib.lists.optionals true ["${user}" "users" "video" "seat"])
            (lib.lists.optionals
              config.users.users.${user}.isSystemUser ["netadmin" "wheel" "wireshark"])
            (lib.lists.optionals
              config.home-manager.users.${user}.frostbite.programs.arduino.enable ["dialout"])
            (lib.lists.optionals
              (config.frostbite.virtualisation.enable && config.users.users.${user}.isSystemUser) ["libvirtd"])
          ];
          openssh.authorizedKeys.keys = config.frostbite.ssh.publicKeys;
        });
    };
  };
}
