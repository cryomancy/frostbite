{
  lib,
  config,
  ...
}: let
  cfg = config.fuyuNoKosei.git;
in {
  options = {
    fuyuNoKosei.git = {
      enable = lib.mkOption {
        default = true;
        example = false;
        description = "git";
      };
      userName = lib.mkOption {
        default = null;
        type = lib.types.string;
        example = "Foo Bar";
      };
      userEmail = lib.mkOption {
        default = null;
        type = lib.types.string;
        example = "foo@bar.com";
      };
    };
  };

  config = lib.mkIf cfg.enable {
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

        userName = cfg.userName;
        userEmail = cfg.UserEmail;

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
