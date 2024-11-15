{
  inputs,
  system,
  lib,
  pkgs,
  pkgs-stable ? {},
  localLib,
  vars,
  overlays,
  modules,
  users,
  hostName,
}: let
  inherit (inputs) home-manager chaotic;
  inherit (localLib) baseNixosModules baseHomeModules;
  specialArgs = {inherit inputs system pkgs pkgs-stable localLib vars overlays users hostName;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      baseNixosModules
      ++ [chaotic.nixosModules.default]
      ++ modules.nixos
      ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup_delete";
            extraSpecialArgs = specialArgs;
            users = lib.attrsets.genAttrs users (user: {
              imports = baseHomeModules ++ modules.${user}.homeManager;
              config.home.username = user;
            });
          };
        }
      ];
  }
