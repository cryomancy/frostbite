_: {
  lib,
  config,
  ...
}: let
  cfg = config.frostbite.virtualisation.binfmt;
in {
  options = {
    frostbite.virtualisation.binfmt = lib.mkOption {
      type = lib.types.submodule {
        enable = lib.mkOption {
          default = true;
          type = lib.types.bool;
        };
        options = {};
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];
  };
}
