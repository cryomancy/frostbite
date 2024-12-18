{
  description = "NixOS configuration that supports multiple users, systems, and architectures.";

  outputs = {
    inputs,
    self,
  }:
    import ./outputs.nix {inherit inputs self;};

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
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
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
    systems = {
      url = "github:nix-systems/default-linux";
    };
    /*
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
    # Editor
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
