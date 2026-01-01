_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.networking.bluetooth;
  isLaptop = config.frostbite.security.useCase == "laptop";
in
{
  options = {
    frostbite.networking.bluetooth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = if isLaptop then true else false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = { };
    };

    services = {
      blueman.enable = true;
      gpsd.enable = true;
    };
    environment.systemPackages = with pkgs; [
      # blueman-applet
      bluez
      bluez-tools
      blueman
      pipewire
    ];
  };
}
