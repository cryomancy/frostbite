{
  inputs,
  system,
  pkgs,
}: let
  overlays = inputs.haumea.lib.load {
    src = ../overlays;
    inputs = {inherit inputs system pkgs;};
  } |> builtins.attrValues;
in
  overlays
