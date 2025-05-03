_: {
  inputs,
  src,
}: let
  inherit (inputs) eris nixpkgs;
  inherit (nixpkgs) lib;

  view = eris.lib.load {
    inherit src;
    loader = eris.lib.loaders.scoped;
  };
in
  lib.pipe view [
    (lib.attrsets.mapAttrsRecursiveCond (x: builtins.isAttrs x)
      (n: v: {module = {${lib.lists.last n} = v;};}))
    (lib.attrsets.collect (x: x ? module))
    (builtins.map (x: builtins.attrValues x))
    lib.lists.flatten
    lib.attrsets.mergeAttrsList
  ]
