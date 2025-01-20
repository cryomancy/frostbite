{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    haumea,
    self,
    ...
  }: {
    lib = haumea.lib.load {
      src = ./lib;
      loader = haumea.lib.loaders.scoped;
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
}
