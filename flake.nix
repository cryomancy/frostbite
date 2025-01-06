{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs self;} (
      {
        withSystem,
        flake-parts-lib,
        ...
      }: let
        inherit (flake-parts-lib) importApply;
        flakeModules =
          inputs.nixpkgs.lib.attrsets.genAttrs ["partitions"] (module:
            importApply ./flake-parts/${module}/flake-module.nix {inherit withSystem;});
        flakeModule = flakeModules;
      in {
        debug = true;
        systems = ["x86_64-linux"];
        imports =
          [
            inputs.flake-parts.flakeModules.partitions
            inputs.flake-parts.flakeModules.flakeModules
            inputs.flake-parts.flakeModules.modules
            inputs.flake-parts.flakeModules.easyOverlay
          ]
          ++ inputs.nixpkgs.lib.attrsets.attrValues flakeModules;

        flake = {
          inherit flakeModule flakeModules;
          extensibleModules = {
            nixos = inputs.haumea.lib.load {
              src = ./flake-parts/modules/nixos;
              loader = inputs.haumea.lib.loaders.verbatim;
              transformer = inputs.haumea.lib.transformers.hoistAttrs "config" "nixos";
            };
            home = inputs.haumea.lib.load {
              src = ./flake-parts/modules/home;
              loader = inputs.haumea.lib.loaders.verbatim;
              transformer = inputs.haumea.lib.transformers.hoistAttrs "config" "home";
            };
          };
          lib = inputs.haumea.lib.load {
            src = ./flake-parts/lib;
            loader = inputs.haumea.lib.loaders.verbatim;
          };
        };
      }
    );
}
