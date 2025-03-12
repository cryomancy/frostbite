{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;}
    ({
      config,
      flake-parts-lib,
      self,
      # moduleWithSystem,
      withSystem,
      ...
    }: let
      inherit inputs;
      inherit (flake-parts-lib) importApply;
      flakeModules = {
        apps = import ./modules/flake/apps.nix {inherit inputs;};
        lib = import ./modules/flake/lib.nix {inherit inputs;};
        modules = importApply ./modules/flake/modules.nix {inherit config inputs;};
        partitions = import ./modules/flake/partitions/partitions.nix;
        systems = import ./modules/flake/systems.nix;
        templates = import ./modules/flake/templates.nix;
      };
    in {
      #_module.specialArgs.inputs = config._module.specialArgs.inputs;
      # // {_modules.specialArgs.inputs.kosei = config._module.specialArgs.self.outputs;};

      imports = [
        flake-parts.flakeModules.modules
        flake-parts.flakeModules.partitions
        flakeModules.apps
        flakeModules.lib
        flakeModules.partitions
        flakeModules.systems
        flakeModules.templates
        flakeModules.modules
      ];

      flake = {
        inherit flakeModules;
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
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
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
