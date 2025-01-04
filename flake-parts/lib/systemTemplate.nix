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
  specialArgs = {inherit inputs system pkgs overlays users hostName;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        inputs.nixosModules.fuyuNoKosei.nixosModules
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            # Iterates over a list of users provided in the function call
            users = lib.attrsets.genAttrs users (user: {
              imports = [inputs.homeModules.fuyuNoKosei.homeModules];
              config.home.username = user;
            });
          };
        }
      ]
      ++ extraConfig;
  }
