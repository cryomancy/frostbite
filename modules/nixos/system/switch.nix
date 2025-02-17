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
        enable = true;
        enableNg = true;
      };
      includeBuildDependencies = true;
      etc = {
        overlay = {
          enable = true;
          mutable = false;
        };
      };
      build = {
        # seperateActivationScript = ;
      };
    };
  };
}
