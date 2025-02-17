scoped: {
  extraModules ? [],
  inputs,
  system,
  outPath,
  users,
  ...
}: let
  inherit (inputs) kosei home-manager nixpkgs;
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    hostPlatform = system;
  };
  specialArgs = {inherit inputs system pkgs outPath users;};
in
  nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules =
      [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true; # Use system nixpkgs, remove impure dependencies
            useUserPackages = true; # Installs packages to /etc/profiles
            extraSpecialArgs = specialArgs;
            # Iterates over a list of users provided in the function call
            users = nixpkgs.lib.attrsets.genAttrs users (user: {
              imports =
                nixpkgs.lib.forEach
                (builtins.attrNames kosei.modules.homeManager)
                (module: builtins.getAttr module kosei.modules.homeManager);
              config.home.username = user;
            });
          };
        }
      ]
      ++ extraModules
      ++ nixpkgs.lib.forEach
      (builtins.attrNames kosei.modules.nixos)
      (module: builtins.getAttr module kosei.modules.nixos);
  }
