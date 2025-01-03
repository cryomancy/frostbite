{
  inputs,
  pkgs,
  system,
  hostName,
  extraConfig,
  users,
  lib,
  overlays,
}: let
  inherit (inputs) home-manager homeModules nixosModules;
  specialArgs = {inherit inputs system pkgs overlays users hostName;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        nixosModules.fuyuNoKosei.nixosModules
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            # Iterates over a list of users provided in the function call
            users = lib.attrsets.genAttrs users (user: {
              imports = [homeModules.fuyuNoKosei.homeModules];
              config.home.username = user;
            });
          };
        }
      ]
      ++ extraConfig;
  }
