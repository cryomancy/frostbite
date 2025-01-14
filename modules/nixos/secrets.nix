scoped: {
  config,
  inputs,
  lib,
  pkgs,
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
        default = null;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
        plugins = [pkgs.age-plugin-yubikey];
      };
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";
      secrets = lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs users (user: {
        "${user}/hashedPasswordFile" = {
          neededForUsers = true;
        };
      })));
    };
    environment.variables = {
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
    };
  };
}
