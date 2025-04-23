_: {
  extraModules ? [],
  inputs,
  system,
  outPath,
  ...
}: let
  inherit (inputs) frostbite home-manager nixpkgs;
  specialArgs = {inherit inputs system outPath;};
in
  nixpkgs.lib.nixosSystem {
    pkgs = inputs.frostbite.legacyPackages.${system};
    inherit specialArgs;
    modules =
      [
        home-manager.nixosModules.home-manager
        ({config, ...}: {
          home-manager = {
            backupFileExtension = "bak";
            extraSpecialArgs = specialArgs;
            useGlobalPkgs = true; # Use system nixpkgs, remove impure dependencies
            useUserPackages = true; # Installs packages to /etc/profiles
            # Iterates over a list of users provided in the function call
            users =
              nixpkgs.lib.attrsets.genAttrs (nixpkgs.lib.attrsets.attrNames config.frostbite.users.users)
              (user: {
                imports =
                  nixpkgs.lib.forEach
                  (builtins.attrNames frostbite.modules.homeManager)
                  (module: builtins.getAttr module frostbite.modules.homeManager);
                config.home.username = user;
                config._module.args = {inherit user;};
              });
          };
        })
      ]
      ++ extraModules
      ++ nixpkgs.lib.forEach
      (builtins.attrNames frostbite.modules.nixos)
      (module: builtins.getAttr module frostbite.modules.nixos);
  }
