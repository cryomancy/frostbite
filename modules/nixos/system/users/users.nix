scoped: {
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  cfg = config.kosei.users;
  user = import ./options/__user.nix;
in {
  options = {
    kosei = {
      users = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            If enabled, users will be managed by Kosei and it's options.
          '';
        };

        users = lib.mkOption {
          type = with lib.types; attrsOf (submodule user);
          example = {
            tahlon = {
              home = "/home/tahlon";
              isAdministrator = true;
            };
          };
          description = ''
            Additional user accounts to be created automatically by the system.
            This can also be used to set options for root.
            Password is either set through the global initalPassword option below,
            the submodule's initialPassword option, or with sops-nix;
          '';
        };

        initialPassword = lib.mkOption {
          type = lib.types.str;
          default = "nixos";
          description = ''
            A password that will be set as the initial password for all new users.
            This is used if the secrets module does not set passwords.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sysusers.enable = true;

    users = {
      mutableUsers = lib.mkDefault (
        if config.kosei.secrets.enable
        then false
        else true
      );

      users =
        lib.genAttrs (lib.attrsets.attrNames cfg.users) # Retrieve all usernames
        
        (user: {
          inherit
            (cfg.users.${user})
            name
            isSystemUser
            isNormalUser
            isAdministrator
            home
            shell
            createHome
            hashedPasswordFile
            initialPassword
            ; # Inherit user-defined options
          extraGroups = lib.lists.concatLists [
            (lib.lists.optionals true ["${user}" "users" "video" "seat"])
            (lib.lists.optionals
              cfg.users.${user}.isAdministrator ["netadmin" "wheel" "wireshark"])
            (lib.lists.optionals
              config.home-manager.users.${user}.kosei.arduino.enable ["dialout"])
            (lib.lists.optionals
              (config.kosei.virtualization.enable && cfg.users.${user}.isAdministrator) ["libvirtd"])
          ];
          openssh.authorizedKeys.keys = config.kosei.ssh.publicKeys;
        });
    };

    # Recovery Account
    # Does not use Yubikey authentication / other PAM methods
    users.extraUsers.recovery = lib.mkIf (config.kosei.security.level
      < 4
      && config.kosei.secrets.enable) {
      name = "recovery";
      description = "Recovery Account";
      isNormalUser = true;
      uid = 1100;
      group = "users";
      extraGroups = ["wheel"];
      useDefaultShell = true;
      hashedPasswordFile = config.sops.secrets."recovery/hashedPasswordFile".path;
    };
  };
}
