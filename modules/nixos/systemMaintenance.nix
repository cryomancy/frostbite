scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.systemMaintenance;
in {
  options = {
    kosei.systemMaintenance = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    system = {
      stateVersion = "24.11";
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
