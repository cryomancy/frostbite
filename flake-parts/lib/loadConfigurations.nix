{inputs, ...}: let
  inherit (inputs) haumea nixpkgs;
  inherit (nixpkgs) lib;
  systems = haumea.lib.load {
    src = ./flake-parts/systems;
    loader = haumea.lib.loaders.verbatim;
  };

  systemNames = builtins.attrNames systems;

  nixosConfigurations =
    lib.attrsets.genAttrs systemNames
    (system:
      haumea.lib.load
      {
        src = ./flake-parts/systems/${system};
        inputs = {inherit inputs lib;};
      });
in
  nixosConfigurations
