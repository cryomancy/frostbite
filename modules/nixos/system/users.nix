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
        initialPassword = lib.mkOption {
          type = lib.types.str;
          default = "nixos";
          description = ''
            A password that will be set as the initial password for all new users.
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
        lib.genAttrs users
        (user: {
          home = "/home/${user}";
          initialPassword = lib.mkDefault (
            if !config.kosei.secrets.enable
            then cfg.initialPassword
            else null
          );
          hashedPasswordFile = lib.mkDefault (
            if config.kosei.secrets.enable
            then config.sops.secrets."${user}/hashedPasswordFile".path
            else null
          );
          isNormalUser = true;
          # TODO: variable shell for multi-user system?
          shell = pkgs.fish;
          # TODO: add logic to not add users to all groups depending on role
          extraGroups = lib.lists.concatLists [
            (lib.lists.optionals true ["${user}" "users" "video" "wheel" "seat"])
            (lib.lists.optionals (config.kosei.security.level < 4) ["netadmin" "wireshark"])
            (lib.lists.optionals (config.kosei.security.level < 4) ["wheel"])
            (lib.lists.optionals config.home-manager.users.${user}.kosei.arduino.enable ["dialout"])
            (lib.lists.optionals config.kosei.virtualization.enable ["libvirtd"])
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
