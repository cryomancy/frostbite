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
    nixosConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) dataWithoutPaths);
  };
in
  outputs // {inherit data;}
