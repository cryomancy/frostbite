{inputs}: let
  systems = ["x86_64-linux"];
  forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
  genConfig = inputs.nixpkgs.lib.attrsets.mergeAttrsList;

  nixosModules.fuyuNoKosei = import ./modules/nixos;
  homeManagerModules.fuyuNoKosei = import ./modules/home;

  lib =
    forEachSystem (system:
      (import ./lib {inherit inputs system pkgs;}).lib // inputs.nixpkgs.lib);

  pkgs = forEachSystem (system:
    import inputs.nixpkgs {
      inherit system;
      inherit (lib.${system}.overlays) overlays;
      config.allowUnfree = true;
    });
in {
  inherit pkgs lib forEachSystem genConfig nixosModules homeManagerModules;
}
