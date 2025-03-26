_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.virtualization.binfmt;
in {
  options = {
    kosei.virtualization.binfmt = lib.mkOption {
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
    boot.binfmt.emulatedSystems = ["aarch64-linux" "riscv64-linux"];
  };
}
