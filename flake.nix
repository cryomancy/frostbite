{
  description = "NixOS configuration that supports multiple users, systems, and architectures.";

  outputs = inputs: import ./outputs {inherit inputs;};

  inputs = {
    /*
         ___           ___           ___           ___           ___           ___           ___           ___
        /\  \         /\  \         /\  \         /\__\         /\  \         /\  \         /\  \         /\  \
       /::\  \       /::\  \       /::\  \       /:/  /        /::\  \       /::\  \       /::\  \       /::\  \
      /:/\:\  \     /:/\:\  \     /:/\:\  \     /:/__/        /:/\:\  \     /:/\:\  \     /:/\:\  \     /:/\ \  \
     /::\~\:\  \   /::\~\:\  \   /:/  \:\  \   /::\__\____   /::\~\:\  \   /:/  \:\  \   /::\~\:\  \   _\:\~\ \  \
    /:/\:\ \:\__\ /:/\:\ \:\__\ /:/__/ \:\__\ /:/\:::::\__\ /:/\:\ \:\__\ /:/__/_\:\__\ /:/\:\ \:\__\ /\ \:\ \ \__\
    \/__\:\/:/  / \/__\:\/:/  / \:\  \  \/__/ \/_|:|~~|~    \/__\:\/:/  / \:\  /\ \/__/ \:\~\:\ \/__/ \:\ \:\ \/__/
          \::/  /       \::/  /   \:\  \          |:|  |          \::/  /   \:\ \:\__\    \:\ \:\__\    \:\ \:\__\
           \/__/        /:/  /     \:\  \         |:|  |          /:/  /     \:\/:/  /     \:\ \/__/     \:\/:/  /
                       /:/  /       \:\__\        |:|  |         /:/  /       \::/  /       \:\__\        \::/  /
                       \/__/         \/__/         \|__|         \/__/         \/__/         \/__/         \/__/
    */
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
        ___           ___           ___           ___           ___                       ___           ___
       /\  \         /\  \         /\  \         /\__\         /\  \          ___        /\  \         |\__\
      /::\  \       /::\  \       /::\  \       /:/  /        /::\  \        /\  \       \:\  \        |:|  |
     /:/\ \  \     /:/\:\  \     /:/\:\  \     /:/  /        /:/\:\  \       \:\  \       \:\  \       |:|  |
    _\:\~\ \  \   /::\~\:\  \   /:/  \:\  \   /:/  /  ___   /::\~\:\  \      /::\__\      /::\  \      |:|__|__
    /\ \:\ \ \__\ /:/\:\ \:\__\ /:/__/ \:\__\ /:/__/  /\__\ /:/\:\ \:\__\  __/:/\/__/     /:/\:\__\     /::::\__\
    \:\ \:\ \/__/ \:\~\:\ \/__/ \:\  \  \/__/ \:\  \ /:/  / \/_|::\/:/  / /\/:/  /       /:/  \/__/    /:/~~/~
     \:\ \:\__\    \:\ \:\__\    \:\  \        \:\  /:/  /     |:|::/  /  \::/__/       /:/  /        /:/  /
      \:\/:/  /     \:\ \/__/     \:\  \        \:\/:/  /      |:|\/__/    \:\__\       \/__/         \/__/
       \::/  /       \:\__\        \:\__\        \::/  /       |:|  |       \/__/
        \/__/         \/__/         \/__/         \/__/         \|__|
    */
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    /*
    INFRASTRUCTURE
    */
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
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    systems = {
      url = "github:nix-systems/default-linux";
    };
    /*
       ___           ___           ___           ___       ___
      /\  \         /\  \         /\  \         /\__\     /\  \
      \:\  \       /::\  \       /::\  \       /:/  /    /::\  \
       \:\  \     /:/\:\  \     /:/\:\  \     /:/  /    /:/\ \  \
       /::\  \   /:/  \:\  \   /:/  \:\  \   /:/  /    _\:\~\ \  \
      /:/\:\__\ /:/__/ \:\__\ /:/__/ \:\__\ /:/__/    /\ \:\ \ \__\
     /:/  \/__/ \:\  \ /:/  / \:\  \ /:/  / \:\  \    \:\ \:\ \/__/
    /:/  /       \:\  /:/  /   \:\  /:/  /   \:\  \    \:\ \:\__\
    \/__/         \:\/:/  /     \:\/:/  /     \:\  \    \:\/:/  /
                   \::/  /       \::/  /       \:\__\    \::/  /
                    \/__/         \/__/         \/__/     \/__/
    */
    home-manager = {
      url = "github:nix-community/home-manager";
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
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    /*
         ___                       ___           ___
        /\__\          ___        /\  \         /\  \
       /::|  |        /\  \      /::\  \       /::\  \
      /:|:|  |        \:\  \    /:/\ \  \     /:/\:\  \
     /:/|:|__|__      /::\__\  _\:\~\ \  \   /:/  \:\  \
    /:/ |::::\__\  __/:/\/__/ /\ \:\ \ \__\ /:/__/ \:\__\
    \/__/~~/:/  / /\/:/  /    \:\ \:\ \/__/ \:\  \  \/__/
          /:/  /  \::/__/      \:\ \:\__\    \:\  \
         /:/  /    \:\__\       \:\/:/  /     \:\  \
        /:/  /      \/__/        \::/  /       \:\__\
        \/__/                     \/__/         \/__/
    */
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
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
    base16 = {
      url = "github:SenchoPens/base16.nix";
    };
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
  };
}
