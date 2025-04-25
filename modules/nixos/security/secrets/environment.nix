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
    frostbite.security.secrets = {
      defaultSopsFile = lib.mkOption {
        type = lib.types.path;
        default = "${outPath}/src/secrets/secrets.yaml";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/".directories = ["/var/lib/sops-nix"];
      };

      variables = {
        SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
      };
    };

    # TODO: Create pkgs.runCommand to create this file if not present?
    sops = {
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
      };
      inherit (cfg) defaultSopsFile;
      defaultSopsFormat = "yaml";
    };
  };
}
