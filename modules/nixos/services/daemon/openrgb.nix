_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.services.daemon.openrgb;
  # TODO: Integrate with Stylix
  inherit (config.frostbite.display.design.theme) theme;
  setColor = theme: ''${lib.getExe pkgs.openrgb} --client -c ${lib.removePrefix "#" theme} -m static'';
in {
  options = {
    frostbite.services.daemon.openrgb = {
      enable = lib.mkEnableOption "rgb";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/".directories = ["/var/lib/openrgb"];
    };
    services.hardware.openrgb = {
      enable = true;
      server.port = 6742;
    };

    services.rgb = {
      Unit.Description = "Set RGB colors to match Stylix";
      Service = {
        Type = "oneshot";
        ExecStart = setColor "random";
        ExecStop = setColor "#000000";
        Restart = "on-failure";
        RemainAfterExit = true;
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
