# does not truly recurse but lays a foundation to continue
scoped: {
  inputs,
  src,
}: let
  inherit (inputs) haumea nixpkgs;
  inherit (nixpkgs) lib;
  inherit (lib) pipe attrsets;
  inherit (attrsets) filterAttrs mergeAttrsList;
  inherit (builtins) attrValues isAttrs;
  loadModules = haumea.lib.load {
    inherit src;
    loader = haumea.lib.loaders.scoped;
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
