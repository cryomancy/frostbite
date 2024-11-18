{
  inputs,
  lib,
  ...
} @ arguments: let
  inherit (inputs) haumea;

  data = haumea.lib.load {
    src = ./src;
    inputs = arguments;
  };

  dataWithoutPaths = builtins.attrValues data;

  outputs = {
    nixOnDroidConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixOnDroidConfigurations or {}) dataWithoutPaths);
  };
in
  outputs // {inherit data;}
