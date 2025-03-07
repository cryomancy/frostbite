{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  outputs = inputs @ {
    eris,
    flake-parts,
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
          module = ./modules/flake/partitions/dev;
          extraInputsFlake = ./modules/flake/partitions/dev;
        };
      };

      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
        herculesCI = "dev";
      };

      perSystem = {pkgs, ...}: {
        apps = {
          generateAgeKey = {
            program = self.lib.generateAgeKey {inherit pkgs;};
          };
          makeIso = {
            program = self.lib.iso {inherit inputs;};
          };
          partitionDisk = {
            program = self.lib.partitionDisk {inherit pkgs;};
          };
          yubikeyInit = {
            program = self.lib.yubikeyInit {inherit pkgs;};
          };
          yubikeyTest = {
            program = self.lib.yubikeyTest {inherit pkgs;};
          };
          viewInputs = {
            program = self.lib.viewInputs {inherit pkgs;};
          };
        };
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
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-droid.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-stable.url = "github:/nixos/nixpkgs/nixos-24.11";
    nixpkgs-master.url = "github:/nixos/nixpkgs";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs = {
        nixpkgs.follows = "nixpkgs-droid";
      };
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    sops-nix = {
      url = "github:TahlonBrahic/sops-nix";
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
