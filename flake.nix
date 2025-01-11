{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {haumea, ...}: {
    lib = haumea.lib.load {
      src = ./lib;
      loader = haumea.lib.loaders.scoped;
    };
    modules = {
      nixos =
        haumea.lib.load
        {
          src = ./modules/nixos;
          loader = haumea.lib.loaders.scoped;
        };
      home =
        haumea.lib.load
        {
          src = ./modules/home;
          loader = haumea.lib.loaders.scoped;
        };
    };
  };
}
