scoped: {
  config,
  inputs,
  lib,
  pkgs,
  outPath,
  users,
  ...
}: let
  cfg = config.kosei.secrets;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options = {
    kosei.secrets = {
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

  config = lib.mkIf cfg.enable {
    environment = {
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/".directories = ["/var/lib/sops-nix"];
      };

      systemPackages = with pkgs; [
        age # Simple, secure, modern encryption tool
        # sops # this needs to be replaced with my sops
      ];

      variables = {
        SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
      };
    };

    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
      };
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";
      secrets = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs users (user: {
          "${user}/hashedPasswordFile" = {neededForUsers = true;};
        }))))

        (lib.attrsets.optionalAttrs
          (config.kosei.security.level < 4)
          {"recovery/hashedPasswordFile" = {neededForUsers = true;};})

        (
          lib.attrsets.optionalAttrs
          config.kosei.networking.enable
          (lib.attrsets.mergeAttrsList (
            lib.lists.forEach
            config.kosei.networking.wirelessNetworks (
              network: {"network/${network}/psk" = {};}
            )
          ))
        )
      ];

      templates = {
        "wireless.conf" = lib.attrsets.optionalAttrs config.kosei.networking.enable {
          content =
            lib.strings.concatLines
            (lib.lists.forEach
              config.kosei.networking.wirelessNetworks (network: ''
                psk_${network}=${config.sops.secrets."network/${network}/psk".path}
              ''));
        };
      };
    };
  };
}
