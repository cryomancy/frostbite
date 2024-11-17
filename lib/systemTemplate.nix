{
  self,
  inputs,
  system,
  lib,
  pkgs,
  localLib,
  vars,
  overlays,
  users,
  hostName,
}: let
  inherit (inputs) home-manager chaotic fuyuNoKosei;
  specialArgs = {inherit inputs system pkgs localLib vars overlays users hostName;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      fuyuNoKosei.nixosModules.fuyuNoKosei
      ++ [chaotic.nixosModules.default]
      ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup_delete";
            extraSpecialArgs = specialArgs;
            users = lib.attrsets.genAttrs users (user: {
              imports = fuyuNoKosei.homeManagerModules.fuyuNoKosei;
              config.home.username = user;
            });
          };
        }
      ];
  }
