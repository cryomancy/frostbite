{inputs}: let
  perSystem = {
    config,
    lib,
    pkgs,
    self',
    system,
    ...
  }: {
    modules = {
      nixos = import ./modules/nixos;
      homeManager = import ./modules/homeManager;
    };
    nixosModules = self'.modules.nixos;
    homeManagerModules = self'.modules.homeManager;

    lib = let
      nixpkgsLib =
        import inputs.nixpkgs
        {
          inherit system;
        }
        .lib;

      fuyuNoKoseiLib =
        import ./lib
        {
          inherit inputs system pkgs;
        };
    in
      nixpkgsLib // fuyuNoKoseiLib;

    pkgs = import inputs.nixpkgs {
      inherit system;
      inherit (lib) overlays;
      config.allowUnfree = true;
    };

    #templates = {
    #  starter = {
    #    path = ./templates/starter;
    #    description = "Fuyu-no-kosei starter template";
    #  };
    #};
    #defaultTemplate = self'.templates.starter;
  };

  systems = ["x86_64-linux" "riscv64-linux" "aarch64-linux"];
  systemOutputs = inputs.nixpkgs.lib.genAttrs systems (system: perSystem // {inherit system;});
in {
  inherit systems;
  nixosModules = builtins.map (o: o.nixosModules) systemOutputs;
  homeManagerModules = builtins.map (o: o.homeManagerModules) systemOutputs;
  pkgs = builtins.map (o: o.pkgs) systemOutputs;
}
