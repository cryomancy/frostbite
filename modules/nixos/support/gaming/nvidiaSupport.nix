_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.support.nvidia.enable;
in {
  options = {
    frostbite.support.nvidia.enable = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
      };
    };
    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';
  };
}
