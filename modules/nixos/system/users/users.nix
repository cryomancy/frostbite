_: {
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  cfg = config.frostbite.users;
  userOpts = import ./options/__user.nix {inherit config lib pkgs;};
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

      users = lib.mkOption {
        default = {};
        type = with lib.types; attrsOf (submodule userOpts);
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
    systemd.sysusers.enable = true;

    users = {
      mutableUsers = lib.mkDefault (
        if config.frostbite.secrets.enable
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
            home
            shell
            createHome
            hashedPasswordFile
            ; # Inherit user-defined options
          initialPassword = cfg.globalIntialPassword;
          extraGroups = lib.lists.concatLists [
            (lib.lists.optionals true ["${user}" "users" "video" "seat"])
            (lib.lists.optionals
              cfg.users.${user}.isAdministrator ["netadmin" "wheel" "wireshark"])
            (lib.lists.optionals
              config.home-manager.users.${user}.frostbite.arduino.enable ["dialout"])
            (lib.lists.optionals
              (config.frostbite.virtualization.enable && cfg.users.${user}.isAdministrator) ["libvirtd"])
          ];
          openssh.authorizedKeys.keys = config.frostbite.ssh.publicKeys;
        });
    };
  };
}
