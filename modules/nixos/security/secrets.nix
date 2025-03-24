_: {
  config,
  inputs,
  lib,
  options,
  outPath,
  users,
  ...
}: let
  cfg = config.kosei.security.secrets;
  userList = lib.attrsets.attrNames users;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options = {
    kosei.security.secrets = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          defaultSopsFile = lib.mkOption {
            type = lib.types.path;
            default = "${outPath}/src/secrets/secrets.yaml";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/".directories = ["/var/lib/sops-nix"];
      };

      variables = {
        SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
      };
    };

    warnings = [
      (
        lib.optionals (cfg.defaultSopsFile == options.kosei.secrets.defaultSopsFile.default)
        ''
          The default sops file location is set by default but not configured by the user.
          If you do not have a sops file at ${cfg.defaultSopsFile} then the
          configuration could fail to build in the future.
        ''
      )
    ];

    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
      };
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";
      secrets = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs userList (user: {
          "${user}/hashedPasswordFile" = {neededForUsers = true;};
        }))))

        (lib.attrsets.optionalAttrs
          (config.kosei.security.level < 4)
          {"recovery/hashedPasswordFile" = {neededForUsers = true;};})

        #(
        #  lib.attrsets.optionalAttrs
        #  config.kosei.networking.enable
        #  (lib.attrsets.mergeAttrsList (
        #    lib.lists.forEach
        #    config.kosei.networking.wirelessNetworks (
        #      network: {"network/${network}/psk" = {neededForUsers = false;};}
        #    )
        #  ))
        #)
      ];

      #templates = {
      #  "wireless.conf" = lib.attrsets.optionalAttrs config.kosei.networking.enable {
      #    content =
      #      lib.strings.concatLines
      #      (lib.lists.forEach
      #        config.kosei.networking.wirelessNetworks (network: ''
      #          psk_${network}=${config.sops.placeholder."network/${network}/psk"}
      #        ''));
      #  };
      #};
    };
  };
}
