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
    ...
  }:
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      modules = {
        nixos = let
          localModules =
            haumea.lib.load
            {
              src = ./modules/nixos;
              loader = haumea.lib.loaders.path;
            };
          nixStorePaths = builtins.attrValues localModules;
          modules = map (module:
            inputs.nixpkgs.lib.path.subpath.join
            (inputs.nixpkgs.lib.lists.sublist 4 7
              (inputs.nixpkgs.lib.strings.splitString "/" module)))
          nixStorePaths;
        in
          modules;
        home = let
          localModules =
            haumea.lib.load
            {
              src = ./modules/home;
              loader = haumea.lib.loaders.path;
            };
          nixStorePaths = builtins.attrValues localModules;
          modules = map (module:
            inputs.nixpkgs.lib.path.subpath.join
            (inputs.nixpkgs.lib.lists.sublist 4 7
              (inputs.nixpkgs.lib.strings.splitString "/" module)))
          nixStorePaths;
        in
          modules;
      };
    });
}
