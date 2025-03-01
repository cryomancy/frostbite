scoped: {
  extraModules ? [],
  hostName ? "nixos",
  inputs ? {},
  outPath,
  system ? "x86_64-linux",
  users ? ["nixos"],
  ...
}: let
  inherit (inputs) kosei home-manager nixpkgs;
  specialArgs = {inherit hostName inputs outPath system users;};
in
  nixpkgs.lib.nixosSystem {
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
            extraSpecialArgs = specialArgs;
            # Iterates over a list of users provided in the function call
            users = inputs.nixpkgs.lib.attrsets.genAttrs users (user: {
              imports =
                nixpkgs.lib.forEach
                (builtins.attrNames kosei.modules.homeManager)
                (module: builtins.getAttr module kosei.modules.homeManager);
              config.home.username = user;
              config._module.args = {inherit user;};
            });
          };
        }
        {
          kosei = {
            boot.enable = true;
            displayManager.enable = true;
            secrets.enable = false;
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
              git.enable = false;
              gpg.enable = false;
              officeUtils.enable = true;
              hyprland = {
                enable = true;
              };
              passwordManagement.enable = true;
              rofi.enable = true;
              waybar.enable = true;
            };
          };
        }
      ]
      ++ extraModules
      ++ nixpkgs.lib.forEach
      (builtins.attrNames kosei.modules.nixos)
      (module: builtins.getAttr module kosei.modules.nixos);
  }
