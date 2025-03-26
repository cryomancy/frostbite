_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.droid.integration;
in {
  options = {
    frostbite.android-integration = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    android-integration = {
      am.enable = true;
      termux-open-url.enable = true;
      termux-reload-settings.enable = true;
      termux-setup-storage.enable = true;
      termux-wake-lock.enable = true;
      termux-wake-unlock.enable = true;
      unsupported.enable = true;
      xdg-open.enable = true;
    };
  };
}
