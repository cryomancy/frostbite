scoped: {
  self ? {},
  extraModules ? [],
  hostName ? "nixos",
  inputs ? self.inputs,
  lib ? inputs.nixpkgs.lib,
  pkgs ? import inputs.nixpkgs {inherit system;},
  system ? "x86_64-linux",
  users ? ["nixos"],
  ...
}: let
  inherit (inputs) kosei home-manager;
in
  lib.nixosSystem {
    inherit system;
    modules =
      [
        {_module.args = {inherit self system hostName users;};}
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs self system hostName users;};
            # Iterates over a list of users provided in the function call
            users = inputs.nixpkgs.lib.attrsets.genAttrs users (user: {
              imports =
                lib.forEach
                (builtins.attrNames kosei.modules.home)
                (module: builtins.getAttr module kosei.modules.home);
              config.home.username = user;
            });
          };
        }
      ]
      ++ extraModules
      ++ lib.forEach
      (builtins.attrNames kosei.modules.nixos)
      (module: builtins.getAttr module kosei.modules.nixos);
  }
