{
  description = "NixOS configuration to bootstrap fuyu-no-kosei.";

  outputs = inputs @ {
    flake-utils,
    nixpkgs,
    kosei,
    ...
  }: let
    inherit (inputs.nixpkgs) lib;
  in
    flake-utils.lib.eachDefaultSystemPassThrough (system: let
      pkgs =
        import nixpkgs
        {
          inherit system;
          config.allowUnfree = true;
        };
    in {
      nixosConfigurations.bootstrap = lib.nixosSystem {
        inherit system;
        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "bak";
              useGlobalPkgs = true;
              useUserPackages = true;
            };
            users.users."temp" = {
              password = "temp";
            };
          }
          inputs.kosei.modules.nixos.boot
          inputs.kosei.modules.nixos.network
          inputs.kosei.modules.nixos.nixSettings
          inputs.kosei.modules.nixos.tools
          inputs.kosei.modules.nixos.ssh
          inputs.kosei.modules.nixos.GNOME
        ];
      };
    });

  inputs = {
    assets = {
      url = "github:TahlonBrahic/assets";
      flake = false;
    };
    kosei = {
      url = "github:TahlonBrahic/fuyu-no-kosei";
      inputs.nixpkgs.follows = "nixpkgs";
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
