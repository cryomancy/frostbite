scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.switch;
in {
  options = {
    kosei.switch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    system = {
      preSwitchChecks = {};
      activationScripts = {};
      userActivationScripts = {};
      rebuild.enableNg = true;
      switch = {
        enable = false;
        enableNg = true;
      };
      includeBuildDependencies = true;

      # NOTE: This is really cool but difficult in practice
      etc = {
        overlay = {
          enable = false;
          mutable = true;
        };
      };
      build = {
        # seperateActivationScript = ;
      };
    };
  };
}
