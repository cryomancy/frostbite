{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.11";
    };
  };

  outputs = {
    flake-utils,
    haumea,
    ...
  }:
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      modules = {
        nixos = let
          modules =
            haumea.lib.load
            {
              src = ./partitions/modules/nixos;
              loader = haumea.lib.loaders.path;
            };
          #nixStorePaths = builtins.attrValues modules;
          #relativeStorePaths = inputs.nixpkgs.lib.strings.splitString
        in {
          imports = builtins.attrValues modules;
        };
        home = let
          modules =
            haumea.lib.load
            {
              src = ./partitions/modules/home;
              loader = haumea.lib.loaders.path;
            };
        in {
          imports = builtins.attrValues modules;
        };
      };
    });
}
