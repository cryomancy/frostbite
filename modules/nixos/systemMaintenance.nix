{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.systemMaintenance;
in {
  options = {
    systemMaintenance = {
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
        flake = inputs.self.outPath;
        flags = [
          "--update-input"
          "nixpkgs"
          "-L"
        ];
      };
    };
  };
}
