{inputs, ...}: let
  inherit (inputs) haumea nixpkgs;
  inherit (nixpkgs) lib;
  systems =
    builtins.attrNames
    (haumea.lib.load {
      src = ./flake-parts/systems;
      loader = haumea.lib.loaders.verbatim;
    });

  systemConfigurations = lib.lists.forEach (system:
    haumea.lib.load {
      src = ./flake-parts/systems/${system};
      inputs = {inherit inputs lib;};
    })
  systems;

  nixosConfigurations = lib.attrsets.mergeAttrsList systemConfigurations;
in
  nixosConfigurations
