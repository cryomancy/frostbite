{
  inputs,
  system,
  modules,
  users,
  hostName
  ...
}: let
  specialArgs = {inherit inputs hostName system users ;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        inputs.nixosModules
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            # Iterates over a list of users provided in the function call
            users = lib.attrsets.genAttrs users (user: {
              imports = [inputs.homeModules];
              config.home.username = user;
            });
          };
        }
      ]
      ++ modules;
  }
