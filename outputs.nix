{
  nixpkgs,
  self,
  systems,
  ...
} @ inputs: let
  forEachSystem = nixpkgs.lib.genAttrs (import systems);
  genConfig = nixpkgs.lib.attrsets.mergeAttrsList;

  nixosModules.fuyuNoKosei = import ./modules/nixos;
  homeManagerModules.fuyuNoKosei = import ./modules/home;

  lib =
    forEachSystem (system:
      (import ./lib {inherit inputs system pkgs;}).lib // nixpkgs.lib);

  pkgs = forEachSystem (system:
    import inputs.nixpkgs {
      inherit system;
      inherit (lib.${system}.overlays) overlays;
      config.allowUnfree = true;
    });

  templates = {
    default = {
      path = ./templates/default;
      description = ''
        A template that includes examples for all systems
      '';
      welcomeText = ''
      '';
    };
    WSL = {
      path = ./templates/WSL;
      description = ''
        A template containing an example only for a single WSL host
      '';
      welcomeText = ''
      '';
    };
  };
in {
  inherit
    pkgs
    lib
    forEachSystem
    genConfig
    nixosModules
    homeManagerModules
    templates
    ;
}
