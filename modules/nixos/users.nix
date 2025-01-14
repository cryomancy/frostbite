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
    kosei.users = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.userborn = {
      enable = true;
    };

    users = {
      mutableUsers = false;
      users =
        lib.genAttrs users
        (user: {
          home = "/home/${user}";
          hashedPasswordFile = lib.mkDefault config.sops.secrets."${user}/hashedPasswordFile".path;
          isNormalUser = true;
          # TODO: variable shell for multi-user system?
          shell = pkgs.fish;
          extraGroups = lib.lists.concatLists [
            (lib.lists.optionals true ["${user}" "users"])
            (lib.lists.optionals (config.kosei.security.level < 4) ["networkmanager" "wireshark"])
            (lib.lists.optionals (config.kosei.security.level < 4) ["wheel"])
            (lib.lists.optionals config.home-manager.users.${user}.kosei.arduino.enable ["dialout"])
          ];
          # openssh.authorizedKeys.keyFiles = [(builtins.readFile config.sops.secrets."${user}/ssh/publicKeys".path)];
        });
    };

    # Recovery Account
    users.extraUsers.recovery = lib.mkIf (config.kosei.security.level
      < 4) {
      name = "recovery";
      description = "Recovery Account";
      isNormalUser = true;
      uid = 1100;
      group = "users";
      extraGroups = ["wheel"];
      useDefaultShell = true;
      initialHashedPassword = config.sops.secrets."recovery/hashedPasswordFile".path;
    };
  };
}
