{inputs}: let
  systems = ["x86_64-linux" "riscv64-linux" "aarch64-linux"];
  forEachSystem = inputs.nixpkgs.lib.genAttrs systems;

  nixosModules = import ./modules/nixos;
  homeManagerModules = import ./modules/homeManager;

  lib =
    forEachSystem (system:
      import ./lib {inherit inputs system pkgs;} // inputs.nixpkgs.lib);

  pkgs = forEachSystem (system:
    import inputs.nixpkgs {
      inherit system;
      inherit (lib) overlays;
      config.allowUnfree = true;
    });
in {
  inherit systems pkgs lib nixosModules homeManagerModules;
}
