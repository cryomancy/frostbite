{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    eris.url = "github:TahlonBrahic/eris";
  };

  outputs = inputs @ {
    eris,
    self,
    ...
  }: {
    lib = eris.lib.load {
      src = ./lib;
      loader = eris.lib.loaders.scoped;
    };

    templates = {
      "bootstrap" = {
        path = ./templates/bootstrap;
        description = "use to enable experimental features needed to switch to kosei modules";
      };

      "multiple-systems" = {
        path = ./templates/multiple-systems;
        description = "example of a multiple systems";
      };
    };

    modules = {
      nixos =
        self.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ./modules/nixos;
        };
      home =
        self.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ./modules/home;
        };
    };
  };
}
