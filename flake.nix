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

  outputs = inputs @ {
    flake-utils,
    haumea,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      modules = let
        inherit (nixpkgs) lib;
      in
        import ./modules/imports.nix {inherit haumea lib;};
    });
}
