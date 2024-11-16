{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.transience;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];

  options = {
    transience.enable = lib.mkEnableOption "transience";
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
