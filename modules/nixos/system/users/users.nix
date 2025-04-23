_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.users;

  # Collects list of defined normal user
  userList =
    lib.attrsets.attrNames
    (lib.filterAttrs (_: v: v.isNormalUser) config.users.users);

  userOpts = _: {
    options = {
      isAdministrator = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = ''
          If enabled, the user will be given access to certain administrative privileges.
        '';
      };
    };
  };
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

      globalIntialPassword = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = ''
          A password that will be set as the initial password for all new users.
          This is used if the secrets module does not set passwords.
        '';
      };

      # Abstraction over config.users.users
      # Includes pre-defined options so you can easily
      # define users with the options below instead of
      # the cumbersome NixOS options.
      users = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.submodule userOpts);
        example = {
          main-user = {
            isAdministrator = true;
          };
          regular-guy = {};
        };
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
        lib.genAttrs userList
        (user: {
          extraGroups = lib.lists.concatLists [
            (lib.lists.optionals true ["${user}" "users" "video" "seat"])
            (lib.lists.optionals
              config.users.users.${user}.isAdministrator ["libvirtd" "netadmin" "network" "wheel" "wireshark"])
            (lib.lists.optionals
              config.home-manager.users.${user}.frostbite.programs.arduino.enable ["dialout"])
          ];

          # Aggregates all given trusted ssh public keys to be added to all users.
          openssh.authorizedKeys.keys = config.frostbite.ssh.publicKeys;

          #home = "/home/${user}";
          group = "users";
          #createHome = true;
        });
    };
  };
}
