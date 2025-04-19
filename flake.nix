{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;}
    (
      {
        config,
        self,
        ...
      }: let
        flakeModules = {
          apps = import ./modules/flake/apps.nix {inherit config self;};
          legacyPackages = import ./modules/flake/legacyPackages.nix {inherit inputs;};
          lib = import ./modules/flake/lib.nix {inherit inputs;};
          modules = import ./modules/flake/modules.nix {inherit config self inputs;};
          nixosConfigurations = import ./modules/flake/nixosConfigurations.nix {inherit config self;};
          partitions = import ./modules/flake/partitions/partitions.nix;
          systems = import ./modules/flake/systems.nix;
          templates = import ./modules/flake/templates.nix;
        };
      in {
        imports = [
          flake-parts.flakeModules.modules
          flake-parts.flakeModules.partitions
          flakeModules.apps
          flakeModules.legacyPackages
          flakeModules.lib
          flakeModules.nixosConfigurations
          flakeModules.partitions
          flakeModules.systems
          flakeModules.templates
          flakeModules.modules
        ];

        flake = {
          inherit flakeModules;
        };
      }
    );

  inputs = {
    assets = {
      url = "github:tahlonbrahic/assets";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    icebox = {
      url = "github:tahlonbrahic/icebox";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    vostok = {
      url = "github:tahlonbrahic/vostok";
    };
    eris = {
      url = "github:tahlonbrahic/eris";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-droid.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-stable.url = "github:/nixos/nixpkgs/nixos-24.11";
    nixpkgs-master.url = "github:/nixos/nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
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
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:tahlonbrahic/sops-nix";
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
