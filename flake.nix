{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

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
        ];

        partitions = {
          assets.extraInputsFlake = ./flake-parts/assets;
          ci.extraInputsFlake = ./flake-parts/ci;
          #checks.extraInputsFlake = ./flake-parts/checks;
          dev.extraInputsFlake = ./flake-parts/dev;
          docs.extraInputsFlake = ./flake-parts/docs;
          installer.extraInputsFlake = ./flake-parts/installer;
        };

        partitionedAttrs = {
          assets = "assets";
          ci = "ci";
          #checks = "checks";
          devShells = "dev";
          docs = "docs";
          installer = "installer";
        };

        perSystem = {
          config,
          system,
          ...
        }: rec {
          _module.args.lib = withSystem system ({system, ...}:
            import ./flake-parts/lib
            {
              inherit system;
              inherit (self) inputs;
              inherit (config._module.args) pkgs;
            }
            // inputs.nixpkgs.lib);
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            inherit (config.lib.overlays) overlays;
            config.allowUnfree = true;
          };
          inherit (_module.args) lib pkgs;
        };

        flake = {
          nixosModules.fuyuNoKosei = {
            nixosModules = import ./flake-parts/modules/nixos;
            homeManagerModules = import ./flake-parts/modules/homeManager;
          };
        };
      }
    );
}
