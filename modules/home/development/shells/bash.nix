_: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.frostbite.shells.bash;
in {
  options = {
    frostbite.shells.bash = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [
          ".config/bash"
        ];
      };
    };
    programs = {
      bash = {
        enable = true;
        shellOptions = [
          "vi"
        ];
        shellAliases = {
         # la = "ls -al";
          #ll = "ls -l";
          #".." = "cd ..";
          #switch = "sudo nixos-rebuild switch";
        };
      };
    };

    home.sessionVariables.SHELL = /etc/profiles/per-user/${config.home.username}/bin/bash;
  };
}
