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
  inherit (inputs) home-manager chaotic nix-on-droid;
  inherit (localLib) baseNixosModules baseHomeModules optionalModules;
  specialArgs = {inherit inputs system pkgs pkgs-stable localLib vars overlays users hostName;};
in
  nix-on-droid.lib.nixOnDroidConfiguration {
    inherit system specialArgs;
    modules =
      baseNixosModules
      ++ [chaotic.nixosModules.default]
      ++ modules.nixos
      ++ [optionalModules.opt.android]
      ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = false;
            useUserPackages = false;
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
