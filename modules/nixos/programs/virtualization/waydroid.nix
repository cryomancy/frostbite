scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.waydroid;
in {
  options = {
    kosei.waydroid.enable = lib.mkEnableOption "waydroid";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = ["/var/lib/waydroid"];
    };

    virtualisation.waydroid.enable = true;
  };
}
