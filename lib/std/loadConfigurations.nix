scoped: importScoped: {
  inputs,
  outPath,
  src,
}: let
  loadSystems = inputs.eris.lib.load {
    inherit src;
    loader = inputs.eris.lib.loaders.verbatim;
  };
  systemNames = builtins.attrNames loadSystems;
in
  inputs.nixpkgs.lib.attrsets.genAttrs systemNames
  (systemName:
    import "${src}/${systemName}/${systemName}.nix"
    {inherit inputs outPath;})
