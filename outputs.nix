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

  systemOutputs = builtins.map (system: perSystem // {inherit system;}) systems;
in {
  inherit systems;
  nixosModules = builtins.map (o: o.nixosModules) systemOutputs;
  homeManagerModules = builtins.map (o: o.homeManagerModules) systemOutputs;
  #templates = builtins.map (o: o.templates) systemOutputs;
  #defaultTemplate = builtins.map (o: o.defaultTemplate) systemOutputs;
  lib = builtins.map (o: o.lib) systemOutputs;
  pkgs = builtins.map (o: o.pkgs) systemOutputs;
}
