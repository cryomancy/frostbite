{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sound;
in {
  options = {
    sound = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      # pulse.enable = true;
      jack.enable = true;
      # wireplumber.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # pulseaudio
      alsa-utils
      alsa-ucm-conf
    ];

    security.rtkit.enable = true;
    # hardware.pulseaudio.enable = false;
  };
}
