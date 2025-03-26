_: {
  lib,
  config,
  user,
  ...
}: let
  cfg = config.frostbite.programs.git;
in {
  options = {
    frostbite.programs.git = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            default = true;
            example = false;
            description = "git";
          };
          userName = lib.mkOption {
            default = null;
            type = lib.types.str;
            example = "Foo Bar";
          };
          userEmail = lib.mkOption {
            default = null;
            type = lib.types.str;
            example = "foo@bar.com";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [".config/git"];
      };
    };
    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        delta.enable = true;
        delta.options = {
          line-numbers = true;
          side-by-side = true;
          navigate = true;
        };

        inherit (cfg) userName userEmail;

        extraConfig = {
          init.defaultBranch = "main";

          push = {
            default = "current";
            autoSetupRemote = true;
          };

          pull = {
            rebase = true;
          };

          merge = {
            conflictstyle = "diff3";
          };

          diff = {
            colorMoved = "default";
          };

          url = {
            "ssh://git@github.com/${cfg.userName}" = {
              insteadOf = "https://github.com/${cfg.userName}";
            };
          };
        };
      };
    };
  };
}
