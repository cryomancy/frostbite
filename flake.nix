{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    haumea.url = "github:nix-community/haumea/v0.2.2";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs self;} (
      {withSystem, ...}: {
        debug = true;

        systems = ["x86_64-linux"];

        imports = [
          ./flake-parts/options/lib.nix
          ./flake-parts/options/pkgs.nix
          flake-parts.flakeModules.partitions
          flake-parts.flakeModules.easyOverlay
        ];

        partitions = {
          assets.extraInputsFlake = ./flake-parts/assets;
          ci.extraInputsFlake = ./flake-parts/ci;
          #checks.extraInputsFlake = ./flake-parts/checks;
          dev.extraInputsFlake = ./flake-parts/dev;
          docs.extraInputsFlake = ./flake-parts/docs;
          installer.extraInputsFlake = ./flake-parts/installer;
        };

        perSystem = {
          config,
          system,
          ...
        }: rec {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [self.overlays.default];
            config.allowUnfree = true;
          };
          inherit (_module.args) pkgs;
          overlayAttrs = {
            fuyuvim = inputs.fuyuvim.overlays.default;
            jeezyvim = inputs.jeezyvim.overlays.default;
            nur = inputs.nur.overlays.default;
            nvchad = final: prev: {
              inherit (inputs.nvchad4nix.packages."${system}".nvchad) nvchad;
            };
          };
        };

        flake = {
          nixosModules.fuyuNoKosei.nixosModules = import ./flake-parts/modules/nixos;
          homeModules.fuyuNoKosei.homeModules = import ./flake-parts/modules/home;
          lib = inputs.haumea.lib.load {
            src = ./flake-parts/lib;
            loader = inputs.haumea.lib.loaders.scoped;
            inputs = {inherit (inputs.nixpkgs) lib;};
          };
        };
      }
    );
}
