_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.network;
in
{
  options.frostbite.network = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable network support";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      # useDHCP = true;
      # wireless.enable = true;
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      networkmanager
      networkmanagerapplet
    ];

    security.rtkit.enable = true;
  };
}
