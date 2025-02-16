{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs = {
    eris.url = "github:TahlonBrahic/eris";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = inputs @ {
    eris,
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;}
    ({
      withSystem,
      flake-parts-lib,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
      #flakeModules.default = importApply ./modules/flake/inputs.nix {inherit withSystem;};
    in {
      debug = true;

      systems = ["x86_64-linux"];

      imports = [
        #inputs.flake-parts.flakeModules.flakeModules
        #flakeModules.default
      ];

      flake = {
        lib = eris.lib.load {
          src = ./lib;
          loader = eris.lib.loaders.scoped;
        };

        templates = {
          "multiple-systems" = {
            path = ./templates/multiple-systems;
            description = "example of a multiple systems";
          };
        };

        modules = {
          nixos =
            self.lib.loadModulesRecursively
            {
              inherit inputs;
              src = ./modules/nixos;
            };
          home =
            self.lib.loadModulesRecursively
            {
              inherit inputs;
              src = ./modules/home;
            };
        };
      };
    });
}
