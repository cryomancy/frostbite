_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.gaming.kernel;
in {
  options = {
    frostbite.gaming.kernel = {
      enable = lib.mkEnableOption "kernel";
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [xone];
      kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
    };
  };
}
