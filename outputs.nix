{inputs}: {
  perSystem = {
    inputs,
    system,
    ...
  }: let
    inherit (inputs.flake-parts) withSystem;
  in {
    flake = rec {
      homeManagerModules.fuyuNoKosei = import ./modules/homeManager;
      nixosModules.fuyuNoKosei = import ./modules/nixos;

      genConfig = inputs.nixpkgs.lib.attrsets.mergeAttrsList;

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

      systems = ["x86_64-linux"];

      lib = withSystem system ((import ./lib {inherit inputs system pkgs;}).lib // inputs.nixpkgs.lib);

      pkgs = withSystem system (import inputs.nixpkgs {
        inherit system;
        inherit (lib.${system}.overlays) overlays;
        config.allowUnfree = true;
      });
    };
  };
}
