{
  inputs,
  system,
  pkgs,
}: let
  inherit (inputs) haumea;
  overlays = haumea.lib.load {
    src = ../overlays;
    inputs = {inherit inputs system pkgs;};
  };
  overlaysAttrs = builtins.attrValues overlays;
in
  overlaysAttrs
