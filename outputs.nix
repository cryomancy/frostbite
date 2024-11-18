{
  self,
  inputs,
}: let
  supportedSystems = ["x86_64-linux" "aarch64-linux"];

  forAllSystems = lib.genAttrs supportedSystems;

  lib = forAllSystems (system:
    import ../lib {
      inherit inputs system;
      pkgs = pkgs.${system};
    });

  pkgs = forAllSystems (system:
    import inputs.nixpkgs
    {
      inherit system;
      inherit (lib.${system}.lib) overlays;
      config.allowUnfree = true;
    });

  nixosModules.fuyu-no-kosei = {
    imports = [
      ./modules/nixos
    ];
  };

  homeManagerModules.fuyu-no-kosei = {
    imports = [
      ./modules/home
    ];
  };

  templates = {
    starter = {
      path = ./templates/starter;
      description = "Fuyu-no-kosei starter template";
    };
  };

  defaultTemplate = self.template.starter;
in {inherit nixosModules homeManagerModules templates defaultTemplate lib;}
