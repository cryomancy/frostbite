_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.security.audit;
  secOpts = config.frostbite.security;
  enableIt = let
    isSecure = secOpts.level != "open";
  in
    if isSecure
    then true
    else false;
in {
  options = {
    frostbite.security.audit = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = lib.mkForce true;
    security = {
      audit = {
        enable = enableIt;
      };
      auditd = {
        enable = enableIt;
      };
    };
  };
}
