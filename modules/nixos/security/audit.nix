_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.security.audit;
  secOpts = config.kosei.security.settings;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    kosei.security.audit = lib.mkOption {
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
    programs.dconf.enable = lib.mkForce true;
    security = {
      audit = {
        enable = !isOpen true;
      };
      auditd = {
        enable = !isOpen true;
      };
    };
  };
}
