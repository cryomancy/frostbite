_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.security;
in {
  options = {
    kosei.security = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      settings = lib.mkOption {
        type = lib.types.submodule;
        options = {
          level = lib.mkOption {};
          location = lib.mkOption {};
          useCase = lib.mkOption {};
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
    security = {
      # Enables authentication via Hyprlock
      # NOTE: Does this need to match a home option?
      pam.services.hyprlock = {};
    };

    services = {
      fail2ban.enable =
        if (cfg.level > 1)
        then true
        else false;
    };
  };
}
