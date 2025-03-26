scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.distributedBuilders;
in {
  options = {
    kosei.distributedBuilders = {
      enable = lib.mkEnableOption "distributed builders";
    };
  };
  config = lib.mkIf cfg.enable {
    nix = {
      extraOptions = ''
        builders-use-substitutes = true
      '';
      distributedBuilds = true;
      buildMachines."hostname" = {
        inherit (config.nixpkgs) system;
        sshKey = "temp";
        sshUser = "root";
        hostName = "localhost";
        maxJobs = 4;
        speedFactor = 4;
        supportedFeatures = ["benchmark" "big-parallel"];
      };
    };
  };
}
