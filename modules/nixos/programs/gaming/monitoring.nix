_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.gaming.monitoring;
in {
  options = {
    frostbite.gaming.monitoring = {
      enable = lib.mkEnableOption "gaming";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lact
      corectrl
    ];

    # GPU Monitoring and Fan Adjustment
    systemd.packages = with pkgs; [lact];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
  };
}
