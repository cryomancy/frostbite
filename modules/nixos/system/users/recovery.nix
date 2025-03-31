_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.users.recovery;
in {
  options = {
    frostbite.users.recovery = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Recovery Account
    # Does not use Yubikey authentication / other PAM methods
    users.extraUsers.recovery = lib.mkIf config.frostbite.security.secrets.enable {
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
