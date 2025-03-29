_: {
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.frostbite.utils.virtualisation;
in {
  options = {
    frostbite.utils.virtualisation = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: add impermanence for distrobox and podman
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".config/k9s"];
        };

        packages = with pkgs; [
          distrobox
          docker-compose
          podman
          podman-tui
          skopeo
          kubectl
          kubevirt
        ];
      };
    };

    programs.k9s.enable = true;
  };
}
