{
  inputs,
  system,
  pkgs,
}: let
  inherit (inputs) haumea;
  vars = haumea.lib.load {
    src = ../vars;
    inputs = {inherit inputs system pkgs;};
  };
in
  vars
