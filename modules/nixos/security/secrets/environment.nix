_: {
  config,
  inputs,
  lib,
  options,
  outPath,
  ...
}: let
  cfg = config.frostbite.security.secrets;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  options = {
    frostbite.security.secrets = lib.mkOption {
      type = lib.types.submodule {
        options = {
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
      persistence = lib.mkIf config.frostbite.impermanence.enable {
        "/nix/persistent/".directories = ["/var/lib/sops-nix"];
      };

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
    };
  };
}
