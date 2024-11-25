{
  config,
  inputs,
  lib,
  users,
  ...
}: let
  cfg = config.secrets;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options = {
    secrets = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      defaultSopsFile = lib.mkOption {
        type = lib.types.path;
        default = ./secrets/secrets.yaml;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
      };
      inherit (cfg.defaultSopsFile) defaultSopsFile;
      defaultSopsFormat = "yaml";
      secrets = lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs users (user: {
        "${user}/hashedPasswordFile" = {
          neededForUsers = true;
        };
      })));
    };
  };
}
