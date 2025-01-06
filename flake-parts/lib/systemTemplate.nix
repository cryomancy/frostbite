{
  inputs,
  system,
  modules,
  users,
  hostName,
  lib,
  ...
}: let
  specialArgs = {inherit inputs hostName system users;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        inputs.fuyuNoKosei.extensibleModules.nixos
        inputs.home-manager.extensibleModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            # Iterates over a list of users provided in the function call
            users = inputs.nixpkgs.lib.attrsets.genAttrs users (user: {
              imports = [inputs.fuyuNoKosei.modules.home];
              config.home.username = user;
            });
          };
        }
      ]
      ++ modules;
  }
