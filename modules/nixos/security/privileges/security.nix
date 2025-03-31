_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.security;
in {
  options = {
    frostbite.security = {
      level = lib.mkOption {
        type = lib.types.enum ["open" "standard" "moderate" "restricted" "strict"];
        default = "standard";
        description = ''
          Security level of the system. Can be 'open' 'standard', 'moderate', 'restricted', or 'strict'.
        '';
      };

      location = lib.mkOption {
        type = lib.types.enum ["local" "dmz" "external" "cloud" "vps" "remote"];
        default = "local";
        description = ''
          Location of the system, indicating its network environment.
          Options: 'local', 'dmz', 'external', 'cloud', 'vps', 'remote'.
        '';
      };

      useCase = lib.mkOption {
        type = lib.types.enum ["server" "workstation" "laptop" "vm"];
        default = "workstation";
        description = "Use case for the system. Options: 'server', 'workstation', 'laptop', 'vm'.";
      };

      lockdownState = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If true, the system is in lockdown mode, restricting certain actions.";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.level == "open" || cfg.level == "standard" || cfg.level == "moderate" || cfg.level == "restricted" || cfg.level == "strict";
        message = "Invalid value for 'level'. Must be one of 'standard', 'moderate', 'restricted', or 'strict'.";
      }
      {
        assertion = cfg.location == "local" || cfg.location == "dmz" || cfg.location == "external" || cfg.location == "cloud" || cfg.location == "vps" || cfg.location == "remote";
        message = "Invalid value for 'location'. Must be one of 'local', 'dmz', 'external', 'cloud', 'vps', or 'remote'.";
      }
      {
        assertion = cfg.useCase == "server" || cfg.useCase == "workstation" || cfg.useCase == "laptop" || cfg.useCase == "vm";
        message = "Invalid value for 'useCase'. Must be one of 'server', 'workstation', 'laptop', or 'vm'.";
      }
      {
        assertion = lib.isBool cfg.lockdownState;
        message = "Invalid value for 'lockdownState'. Must be a boolean (true or false).";
      }
    ];

    warnings = [
      #(lib.optionals
      #  cfg.lockdownState
      #  "Setting lockdownState to true can severely limit system operations. A NixOS rollback may be needed.")
    ];

    security = {
      # Enables authentication via Hyprlock
      # NOTE: Does this need to match a home option?
      pam.services.hyprlock = {};
    };
  };
}
