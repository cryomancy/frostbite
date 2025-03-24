_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.security;
in {
  options = {
    kosei.security.settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          level = lib.mkOption {
            type = lib.types.enum;
            default = "standard";
            description = ''
              Security level of the system. Can be 'open' 'standard', 'moderate', 'restricted', or 'strict'.
            '';
            values = ["open" "standard" "moderate" "restricted" "strict"];
          };

          location = lib.mkOption {
            type = lib.types.enum;
            default = "local";
            description = ''
              Location of the system, indicating its network environment.
              Options: 'local', 'dmz', 'external', 'cloud', 'vps', 'remote'.
            '';
            values = ["local" "dmz" "external" "cloud" "vps" "remote"];
          };

          useCase = lib.mkOption {
            type = lib.types.enum;
            default = "workstation";
            description = "Use case for the system. Options: 'server', 'workstation', 'laptop', 'vm'.";
            values = ["server" "workstation" "laptop" "vm"];
          };

          lockdownState = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "If true, the system is in lockdown mode, restricting certain actions.";
          };
        };
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.settings.level == "open" || cfg.settings.level == "standard" || cfg.settings.level == "moderate" || cfg.settings.level == "restricted" || cfg.settings.level == "strict";
        message = "Invalid value for 'level'. Must be one of 'standard', 'moderate', 'restricted', or 'strict'.";
      }
      {
        assertion = cfg.settings.location == "local" || cfg.settings.location == "dmz" || cfg.settings.location == "external" || cfg.settings.location == "cloud" || cfg.settings.location == "vps" || cfg.settings.location == "remote";
        message = "Invalid value for 'location'. Must be one of 'local', 'dmz', 'external', 'cloud', 'vps', or 'remote'.";
      }
      {
        assertion = cfg.settings.useCase == "server" || cfg.settings.useCase == "workstation" || cfg.settings.useCase == "laptop" || cfg.settings.useCase == "vm";
        message = "Invalid value for 'useCase'. Must be one of 'server', 'workstation', 'laptop', or 'vm'.";
      }
      {
        assertion = lib.isBool cfg.settings.lockdownState;
        message = "Invalid value for 'lockdownState'. Must be a boolean (true or false).";
      }
    ];

    warnings = [
      (lib.optionals
        cfg.settings.lockdownState
        "Setting lockdownState to true can severely limit system operations. A NixOS rollback may be needed.")
    ];

    security = {
      # Enables authentication via Hyprlock
      # NOTE: Does this need to match a home option?
      pam.services.hyprlock = {};
    };
  };
}
