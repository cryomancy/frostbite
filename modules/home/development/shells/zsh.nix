_: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.frostbite.shells.zsh;
in {
  options = {
    frostbite.shells.zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [
          ".config/zsh"
        ];
      };
    };

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "kubectl"
            "history"
            "emoji"
            "encode64"
            "sudo"
            "copyfile"
            "copybuffer"
            "history"
          ];
          theme = "jonathan";
        };
      };
    };

    home.sessionVariables.SHELL = /etc/profiles/per-user/${config.home.username}/bin/zsh;
  };
}
