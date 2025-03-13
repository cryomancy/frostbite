scoped: {
  extraModules ? [],
  inputs,
  system,
  outPath,
  users,
  ...
}: let
  inherit (inputs) kosei home-manager nixpkgs;
  specialArgs = {inherit inputs system outPath users;};
in
  nixpkgs.lib.nixosSystem {
    pkgs = inputs.kosei.legacyPackages.${system};
    inherit specialArgs;
    modules =
      [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            extraSpecialArgs = specialArgs;
            useGlobalPkgs = true; # Use system nixpkgs, remove impure dependencies
            useUserPackages = true; # Installs packages to /etc/profiles
            # Iterates over a list of users provided in the function call
            users = nixpkgs.lib.attrsets.genAttrs users (user: {
              imports =
                nixpkgs.lib.forEach
                (builtins.attrNames kosei.modules.homeManager)
                (module: builtins.getAttr module kosei.modules.homeManager);
              config.home.username = user;
              config._module.args = {inherit user;};
            });
          };
        }
      ]
      ++ extraModules
      ++ nixpkgs.lib.forEach
      (builtins.attrNames kosei.modules.nixos)
      (module: builtins.getAttr module kosei.modules.nixos);
  }
