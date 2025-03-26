_: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.frostbite.security.keepassxc;
in {
  options = {
    frostbite.security.keepassxc = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        keepassxc
        keepassxc-go
        keepass-diff
      ];
    };
  };
}
