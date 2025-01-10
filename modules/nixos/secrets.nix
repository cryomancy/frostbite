scoped: {
  config,
  inputs,
  lib,
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
        # NOTE: for some reason this has to be defined in a user configuration?
        default = ../../../../secrets/secrets.yaml;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
      };
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";
      secrets = lib.attrsets.mergeAttrsList (builtins.attrValues (lib.genAttrs users (user: {
        "${user}/hashedPasswordFile" = {
          neededForUsers = true;
        };
        #"${user}/ssh/publicKey" = {
        #  neededForUsers = true;
        #};
      })));
    };
    environment.variables = {
      # NOTE: this directory could be an issue on a multi-user system with different keys...
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
    };
  };
}
