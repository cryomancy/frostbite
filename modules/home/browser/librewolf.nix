scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.browser.librewolf;
in {
  options = {
    kosei.browser = {
      librewolf.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.librewolf = {
      enable = true;
    };
  };
}
