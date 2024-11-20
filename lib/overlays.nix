{
  inputs,
  system,
  pkgs,
}: let
  overlays = builtins.attrValues inputs.haumea.lib.load {
    src = ../overlays;
    inputs = {inherit inputs system pkgs;};
  };
in {inherit overlays;}
