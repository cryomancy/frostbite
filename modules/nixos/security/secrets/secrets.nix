_: {
  config,
  inputs,
  lib,
  options,
  users,
  ...
}: let
  cfg = config.frostbite.security.secrets;
  userList = lib.attrsets.attrNames users;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options = {
    frostbite.security.secrets = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = [
      (
        lib.optionals (cfg.defaultSopsFile == options.frostbite.secrets.defaultSopsFile.default)
        ''
          The default sops file location is set by default but not configured by the user.
          If you do not have a sops file at ${cfg.defaultSopsFile} then the
          configuration could fail to build in the future.
        ''
      )
    ];

    sops = {
      secrets = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs userList (user: {
          "${user}/hashedPasswordFile" = {neededForUsers = true;};
        }))))

        (lib.attrsets.optionalAttrs
          (!config.frostbite.security.lockdownState)
          {"recovery/hashedPasswordFile" = {neededForUsers = true;};})

        #(
        #  lib.attrsets.optionalAttrs
        #  config.frostbite.networking.enable
        #  (lib.attrsets.mergeAttrsList (
        #    lib.lists.forEach
        #    config.frostbite.networking.wirelessNetworks (
        #      network: {"network/${network}/psk" = {neededForUsers = false;};}
        #    )
        #  ))
        #)
      ];

      #templates = {
      #  "wireless.conf" = lib.attrsets.optionalAttrs config.frostbite.networking.enable {
      #    content =
      #      lib.strings.concatLines
      #      (lib.lists.forEach
      #        config.frostbite.networking.wirelessNetworks (network: ''
      #          psk_${network}=${config.sops.placeholder."network/${network}/psk"}
      #        ''));
      #  };
      #};
    };
  };
}
