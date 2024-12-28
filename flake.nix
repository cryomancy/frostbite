{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }: let
    systems = import inputs.systems;
    forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
  in
    flake-parts.lib.mkFlake {inherit inputs self;} {
      inherit systems;
      flake = rec {
        debug = true;

        homeManagerModules.fuyuNoKosei = import ./modules/homeManager;
        nixosModules.fuyuNoKosei = import ./modules/nixos;

        genConfig = inputs.nixpkgs.lib.attrsets.mergeAttrsList;
        inherit forEachSystem;
        inherit systems;

        templates = {
          default = {
            path = ./templates/default;
            description = ''
              A template that includes examples for all systems
            '';
            welcomeText = ''
            '';
          };
          WSL = {
            path = ./templates/WSL;
            description = ''
              A template containing an example only for a single WSL host
            '';
            welcomeText = ''
            '';
          };
        };

        lib =
          forEachSystem (system:
            (import ./lib {inherit inputs system pkgs;}).lib // inputs.nixpkgs.lib);

        pkgs = forEachSystem (system:
          import inputs.nixpkgs {
            inherit system;
            inherit (lib.${system}.overlays) overlays;
            config.allowUnfree = true;
          });
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    fuyu-no-nur = {
      url = "github:TahlonBrahic/fuyu-no-nur";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    systems = {
      url = "github:nix-systems/default-linux";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jeezyvim = {
      url = "github:LGUG2Z/JeezyVim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fuyuvim = {
      url = "github:TahlonBrahic/fuyu-no-neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Themeing
    base16 = {
      url = "github:SenchoPens/base16.nix";
    };
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    walls = {
      url = "github:dharmx/walls";
      flake = false;
    };
  };
}
