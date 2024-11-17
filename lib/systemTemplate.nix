{
  inputs,
  pkgs,
  system,
  hostName,
  users,
  lib,
  localLib,
  overlays,
}: let
  inherit (inputs) home-manager chaotic fuyuNoKosei;
  specialArgs = {inherit inputs system pkgs localLib overlays users hostName;};
in
  lib.nixosSystem {
    inherit system specialArgs;
    modules =
      fuyuNoKosei.nixosModules.fuyuNoKosei
      ++ [chaotic.nixosModules.default]
      ++ [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = lib.readFile "${pkgs.runCommand "timestamp" {env.when = builtins.currentTime;} "echo -n `date -d @$when +%Y-%m-%d_%H-%M-%S` > $out"}";
            extraSpecialArgs = specialArgs;
            users = lib.attrsets.genAttrs users (user: {
              imports = fuyuNoKosei.homeManagerModules.fuyuNoKosei;
              config.home.username = user;
            });
          };
        }
      ];
  }
