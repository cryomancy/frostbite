{
  inputs,
  system,
  pkgs,
}: let
  inherit (inputs.nixpkgs.lib) genAttrs;

  directories = [
    "overlays"
    "functions"
  ];

  templates = [
    "systemTemplate"
  ];

  # Imports directories list with inputs, system, and pkgs
  importedDirectories = genAttrs directories (directory: import ./${directory}.nix {inherit inputs system pkgs;});

  # Imports templates list without inputs as they are provided on a per-system basis
  importedTemplates = genAttrs templates (template: import ./${template}.nix);

  # Imports the entire directory as an attribute set
  importedFunctions = {imports = [./functions.nix];};

  lib = importedDirectories // importedTemplates // importedFunctions;
in
  lib
