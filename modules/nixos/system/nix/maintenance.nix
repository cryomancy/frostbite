_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.nix.maintenance;
in {
  options = {
    frostbite.nix.maintenance = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: Add clause for servers
    system = {
      stateVersion = "25.04";
      autoUpgrade = {
        enable = true;
        flags = [
          "--update-input"
          "nixpkgs"
          "-L"
        ];
      };
    };
  };
}
