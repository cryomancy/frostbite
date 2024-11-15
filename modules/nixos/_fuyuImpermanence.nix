{inputs, ...}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  config = {
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
