scoped: importScoped: {
  inputs,
  lib,
  pkgs,
  src,
  self,
}: let
  loadSystems = inputs.haumea.lib.load {
    inherit src;
    loader = inputs.haumea.lib.loaders.verbatim;
  };
  systemNames = builtins.attrNames loadSystems;
in
  lib.attrsets.genAttrs systemNames
  (systemName:
    import "${src}/${systemName}/${systemName}.nix"
    {inherit inputs lib pkgs self;})
