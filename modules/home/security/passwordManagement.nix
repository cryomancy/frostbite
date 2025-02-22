scoped: {
  config,
  pkgs,
  lib,
  user,
  ...
}: let
  cfg = config.kosei.passwordManagement;
in {
  options = {
    kosei.passwordManagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        keepassxc
        keepassxc-go
        keepass-diff
      ];

      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".local/share/password-store"];
        };
      };
    };

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-import
        exts.pass-update
      ]);
      settings = {
        PASSWORD_STORE_DIR = config.xdg.dataHome + "/password-store";
        PASSWORD_STORE_KEY = lib.strings.concatStringsSep " " [
          ""
        ];
        PASSWORD_STORE_SIGNING_KEY = lib.strings.concatStringsSep " " [
          ""
        ];
        PASSWORD_STORE_CLIP_TIME = "60";
        PASSWORD_STORE_GENERATED_LENGTH = "20";
        PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
      };
    };

    programs.browserpass = {
      enable = true;
      browsers = [
        "chromium"
        "firefox"
      ];
    };
  };
}
