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
        type = lib.types.anything;
        default = scoped: ./src/secrets/secrets.yaml;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
      };
      defaultSopsFile = cfg.defaultSopsFile "scoped";
      defaultSopsFormat = "yaml";
      secrets =
        lib.mergeAttrs
        (lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs users (user: {
          "${user}/hashedPasswordFile" = {neededForUsers = true;};
        }))))
        (lib.attrsets.optionalAttrs
          (config.kosei.security.level < 4) {"recovery/hashedPasswordFile" = {neededForUsers = true;};});
    };
    environment.variables = {
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
    };
  };
}
