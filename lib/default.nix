{
  inputs,
  system,
  pkgs,
}: let
  inherit (inputs.nixpkgs.lib) genAttrs;

  directories = [
    "vars"
    "overlays"
    "functions"
    "nixosModules"
    "homeManagerModules"
  ];

  templates = [
    "systemTemplate"
  ];

  importedDirectories = genAttrs directories (directory: import ./${directory}.nix {inherit inputs system pkgs;});

  importedTemplates = genAttrs templates (template: import ./${template}.nix);

  importedFunctions = {imports = [./functions.nix];};

  localLib = importedDirectories // importedTemplates // importedFunctions;
in {inherit localLib;}
