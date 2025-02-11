scoped: {
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  cfg = config.kosei.users;
in {
  options = {
    kosei = {
      users = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
        hashedPasswordFile = lib.mkOption {
          type = lib.types.path;
          default = null;
          description = ''
            A path to a password file that will be set as the password for all new users.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.userborn = {
      enable = true;
    };

    users = {
      mutableUsers = lib.mkDefault (
        if config.kosei.secrets.enable
        then false
        else true
      );
      users =
        lib.genAttrs users
        (user: {
          home = "/home/${user}";
          hashedPasswordFile = lib.mkDefault (
            if config.kosei.secrets.enable
            then config.sops.secrets."${user}/hashedPasswordFile".path
            else null
          );
          initialPasswordFile = lib.mkDefault (
            if !config.kosei.secrets.enable
            then cfg.hashedPasswordFile
            else null
          );
          isNormalUser = true;
          # TODO: variable shell for multi-user system?
          shell = pkgs.fish;
          extraGroups = lib.lists.concatLists [
            (lib.lists.optionals true ["${user}" "users"])
            (lib.lists.optionals (config.kosei.security.level < 4) ["networkmanager" "wireshark"])
            (lib.lists.optionals (config.kosei.security.level < 4) ["wheel"])
            (lib.lists.optionals config.home-manager.users.${user}.kosei.arduino.enable ["dialout"])
          ];
          openssh.authorizedKeys.keys = config.kosei.ssh.publicKeys;
        });
    };

    # Recovery Account
    # Does not use Yubikey authentication / other PAM methods
    users.extraUsers.recovery = lib.mkIf (config.kosei.security.level
      < 4) {
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
