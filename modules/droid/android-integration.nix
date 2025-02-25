scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.android-integration;
in {
  options = {
    kosei.android-integration = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
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
