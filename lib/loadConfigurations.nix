scoped: {
  inputs,
  lib,
  pkgs,
}: let
  loadSystems = inputs.haumea.lib.load {
    src = ./src/systems;
    loader = inputs.haumea.lib.loaders.verbatim;
  };
  systemNames = builtins.attrNames loadSystems;
in
  lib.attrsets.genAttrs systemNames
  (systemName:
    import ./src/systems/${systemName}/${systemName}.nix
    {inherit inputs lib pkgs;})
