{inputs}: let
  systems = ["x86_64-linux" "riscv64-linux" "aarch64-linux"];
  forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
  genNixosConfig = inputs.nixpkgs.lib.attrsets.mergeAttrsList;

  nixosModules = import ./modules/nixos;
  homeManagerModules = import ./modules/home;

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
  inherit pkgs lib forEachSystem genNixosConfig nixosModules homeManagerModules;
}
