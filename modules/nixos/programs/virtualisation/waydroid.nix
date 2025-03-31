_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.virtualisation.waydroid;
in {
  options = {
    frostbite.virtualisation.waydroid.enable = lib.mkEnableOption "waydroid";
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/".directories = ["/var/lib/waydroid"];
    };

    virtualisation.waydroid.enable = true;
  };
}
