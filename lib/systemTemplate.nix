{
  inputs,
  pkgs,
  system,
  hostName,
  users,
  lib,
  overlays,
}: let
  nixosConfigurations = let
    inherit (inputs) home-manager fuyuNoKosei;
    specialArgs = {inherit inputs system pkgs overlays users hostName;};
  in
    lib.nixosSystem {
      inherit system specialArgs;
      modules =
        fuyuNoKosei.nixosModules.fuyuNoKosei
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              inherit (lib) backupFileExtension;
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              # Iterates over a list of users provided in the function call
              users = lib.attrsets.genAttrs users (user: {
                imports = fuyuNoKosei.homeManagerModules.fuyuNoKosei;
                config.home.username = user;
              });
            };
          }
        ];
    };
in {inherit nixosConfigurations;}
