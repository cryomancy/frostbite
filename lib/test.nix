{
  inputs,
  src,
}: let
  inherit (inputs) eris nixpkgs;
  inherit (nixpkgs) lib;
  inherit (lib) pipe attrsets;
  inherit (attrsets) filterAttrs mergeAttrsList;
  inherit (builtins) attrValues isAttrs;
  loadModules = eris.lib.load {
    inherit src;
    loader = eris.lib.loaders.scoped;
  };
in
  pipe loadModules
  [
    (filterAttrs (x: y: isAttrs y))
    attrValues # if these returned another layer it would fail right now...
    mergeAttrsList
  ]
  // pipe loadModules
  [
    (filterAttrs (x: y: builtins.isFunction y))
  ]
