{
  description = "Nix flakes abstraction layer that supports multiple users, systems, and architectures.";

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs self;} (
      {withSystem, ...}: {
        debug = true;
        systems = ["x86_64-linux"];
        imports = [
          ./flake-parts/options/lib.nix
          ./flake-parts/options/pkgs.nix
        ];
        perSystem = {
          config,
          system,
          ...
        }: rec {
          _module.args.lib = withSystem system ({system, ...}:
            import ./flake-parts/lib
            {
              inherit system;
              inherit (self) inputs;
              inherit (config._module.args) pkgs;
            }
            // inputs.nixpkgs.lib);
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            inherit (config.lib.overlays) overlays;
            config.allowUnfree = true;
          };
          inherit (_module.args) lib pkgs;
        };
        flake = {
          homeManagerModules.fuyuNoKosei = import ./flake-parts/modules/homeManager;
          nixosModules.fuyuNoKosei = import ./flake-parts/modules/nixos;
        };
      }
    );

  inputs = {
    base16.url = "github:SenchoPens/base16.nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko.url = "github:nix-community/disko";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    fuyu-no-nur.url = "github:TahlonBrahic/fuyu-no-nur";
    fuyuvim.url = "github:TahlonBrahic/fuyu-no-neovim";
    haumea.url = "github:nix-community/haumea/v0.2.2";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    impermanence.url = "github:nix-community/impermanence";
    jeezyvim.url = "github:LGUG2Z/JeezyVim";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:nix-community/nixvim";
    nvchad4nix.url = "github:nix-community/nix4nvchad";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    sops-nix.url = "github:Mic92/sops-nix";
    stylix.url = "github:danth/stylix";
    tt-schemes.url = "github:tinted-theming/schemes";
    tt-schemes.flake = false;
    walls.url = "github:dharmx/walls";
    walls.flake = false;
  };
}
