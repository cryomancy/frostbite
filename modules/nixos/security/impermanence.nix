scoped: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options = {
    kosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = {
      "/nix" = {
        enable = true;
        directories = [
          "/nix/store"
          "/nix/var"
        ];
      };
      "/home" = {
        enable = true;
        directories = [
          "test"
        ];
      };
    };
  };
}
