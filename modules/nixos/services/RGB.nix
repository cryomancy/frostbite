scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.RGB;
  inherit (config.kosei.design.theme) theme;
  setColor = theme: "${lib.getExe pkgs.openrgb} --client -c ${lib.removePrefix "#" theme} -m static";
in {
  options = {
    kosei.RGB = {
      enable = lib.mkEnableOption "rgb";
    };
  };

  environment.persistence = lib.mkIf config.kosei.impermanence.enable {
    "/nix/persistent/".directories = ["/var/lib/OpenRGB"];
  };

  config = lib.mkIf cfg.enable {
    containers.openrgb = {
      autostart = true;
      config = {...}: {
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
    };
  };
}
