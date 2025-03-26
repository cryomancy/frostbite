_: {
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.frostbite.display.hyprland.waypipe;
in {
  options = {
    frostbite.display.hyprland.waypipe.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.kosei.hyprland.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          # QUESTION: Do I need to persist default.target?
          files = [
            ".config/systemd/user/waypipe-client.service"
            ".config/systemd/user/waypipe-server.service"
          ];
        };
      };
      packages = [pkgs.waypipe];
    };

    systemd.user.services = {
      waypipe-client = {
        Unit.Description = "Runs waypipe on startup to support SSH forwarding";
        Service = {
          ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} %h/.waypipe -p";
          ExecStart = "${lib.getExe pkgs.waypipe} --socket %h/.waypipe/client.sock client";
          ExecStopPost = "${lib.getExe' pkgs.coreutils "rm"} -f %h/.waypipe/client.sock";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
      waypipe-server = {
        Unit.Description = "Runs waypipe on startup to support SSH forwarding";
        Service = {
          Type = "simple";
          ExecStartPre = "${lib.getExe' pkgs.coreutils "mkdir"} %h/.waypipe -p";
          ExecStart = "${lib.getExe pkgs.waypipe} --socket %h/.waypipe/server.sock --title-prefix '[%H] ' --login-shell --display wayland-waypipe server -- ${lib.getExe' pkgs.coreutils "sleep"} infinity";
          ExecStopPost = "${lib.getExe' pkgs.coreutils "rm"} -f %h/.waypipe/server.sock %t/wayland-waypipe";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
