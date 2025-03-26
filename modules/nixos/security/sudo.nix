_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.security.sudo;
  secOpts = config.kosei.security.settings;
  strict = lib.lists.any secOpts.level ["restricted" "strict"];
in {
  options = {
    kosei.security.sudo = lib.mkOption {
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
    security = {
      sudo = {
        wheelNeedsPassword =
          if strict
          then true
          else false;
        execWheelOnly = strict true;
        extraConfig =
          lib.strings.concatLines
          [
            ''Defaults lecture = never''
            (lib.strings.optionalString (!strict) "recovery ALL=(ALL:ALL) NOPASSWD:ALL")
          ];
      };
    };
  };
}
