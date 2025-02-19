{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  outputs = inputs @ {
    eris,
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;}
    ({self, ...}: {
      debug = true;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        flake-parts.flakeModules.modules
        flake-parts.flakeModules.partitions
      ];

      partitions = {
        dev = {
          extraInputsFlake = ./module/flake/partitions;
          module = ./modules/flake/partitions/partitions.nix;
        };
      };

      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
        herculesCI = "dev";
      };

      flake = {
        lib = eris.lib.load {
          src = ./lib;
          loader = eris.lib.loaders.scoped;
        };

        templates = {
          "multiple-systems" = {
            path = ./templates/multiple-systems;
            description = "example of a multiple systems";
          };
        };

        modules = {
          flake =
            self.lib.loadModulesRecursively
            {
              inherit inputs;
              src = ./modules/flake;
            };
          nixos =
            self.lib.loadModulesRecursively
            {
              inherit inputs;
              src = ./modules/nixos;
            };
          homeManager =
            self.lib.loadModulesRecursively
            {
              inherit inputs;
              src = ./modules/home;
            };
        };
      };
    });

  inputs = {
    assets = {
      url = "github:TahlonBrahic/assets";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    fuyu-no-nur = {
      url = "github:TahlonBrahic/fuyu-no-nur";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    fuyuvim = {
      url = "github:TahlonBrahic/fuyu-no-neovim";
    };
    eris = {
      url = "github:TahlonBrahic/eris";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    jeezyvim = {
      url = "github:LGUG2Z/JeezyVim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs-stable.url = "github:/nixos/nixpkgs/nixos-24.11";
    #nixpkgs-master.url = "github:/nixos/nixpkgs";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:Flameopathic/stylix/optional-image";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
