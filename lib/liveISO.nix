scoped: {
  extraModules ? [],
  hostName ? "nixos",
  inputs ? {},
  lib ? inputs.nixpkgs.lib,
  pkgs ? import inputs.nixpkgs {inherit system;},
  outPath,
  system ? "x86_64-linux",
  users ? ["nixos"],
  ...
}: let
  inherit (inputs) kosei home-manager nixpkgs;
  specialArgs = {inherit hostName inputs outPath system users;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      [
        (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
        home-manager.nixosModules.home-manager
        {
          networking.wireless.enable = false;
          kosei.secrets.enable = false;
          home-manager = {
            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs // {inherit pkgs;};
            # Iterates over a list of users provided in the function call
            users = inputs.nixpkgs.lib.attrsets.genAttrs users (user: {
              imports =
                lib.forEach
                (builtins.attrNames kosei.modules.home)
                (module: builtins.getAttr module kosei.modules.home);
              config.home.username = user;
              config._module.args = {inherit user;};
            });
          };
        }
        {
          kosei = {
            boot.enable = true;
            displayManager.enable = true;
            ssh = {
              enable = true;
              level = 0;
            };
            design = {
              theme = "${inputs.assets}/themes/nord.yaml";
            };
          };

          home-manager.users = {
            "nixos".kosei = {
              browser.firefox.enable = true;
              fileManager.enable = true;
              git = {
                enable = true;
              };
              homePackages.enable = true;
              hyprland = {
                enable = true;
              };
              rofi.enable = true;
              waybar.enable = true;
            };
          };
        }
      ]
      ++ extraModules
      ++ lib.forEach
      (builtins.attrNames kosei.modules.nixos)
      (module: builtins.getAttr module kosei.modules.nixos);
  }
