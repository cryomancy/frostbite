scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.network;
in {
  options = {
    kosei.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      ##  NOTE: current setup is configure DHCP networkmanager for ease of deployment
      ## as of now further configuration can be done on consumer side with options
      useDHCP = true;
      networkmanager.enable = true;
      usePredictableInterfaceNames = true;
    };

    hardware.bluetooth.enable = true;

    programs.openvpn3 = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnome-control-center
      networkmanagerapplet
    ];

    services = {
      avahi.enable = true;
      blueman.enable = true;
    };
  };
}
