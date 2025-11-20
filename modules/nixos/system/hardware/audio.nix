_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.hardware.audio;
in
{
  options.frostbite.hardware.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sound support";
    };
    lowLatencyOptimizations = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        System optimizations that can be very helpful to reduce xruns and improve responsiveness and are required for certain programs to run at all e.g. Ardour.
      '';
    };
  };

  # Reference: https://nixos.wiki/wiki/JACK

  config = lib.modules.mkMerge [
    (lib.mkIf cfg.enable {
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };

        jack.enable = true;
      };

      environment.systemPackages = with pkgs; [
        alsa-utils
        alsa-ucm-conf
      ];

      security.rtkit.enable = true;
    })

    (lib.mkIf cfg.lowLatencyOptimizations {
      boot = {
        # TODO: add RTK option
        kernelModules = [
          "snd-seq"
          "snd-rawmidi"
        ];
        kernel.sysctl = {
          "fs.inotify.max_user_watches" = 524288;
        };
        kernelParams = [ "threadirq" ];
        postBootCommands = ''
          echo 2048 > /sys/class/rtc/rtc0/max_user_freq
          echo 2048 > /proc/sys/dev/hpet/max-user-freq
          setpci -v -d *:* latency_timer=b0
          setpci -v -s $00:1b.0 latency_timer=ff
        '';
        # The SOUND_CARD_PCI_ID can be obtained like so:
        # $ lspci ¦ grep -i audio
      };
      powerManagement.cpuFreqGovernor = "performance";
      security.pam.loginLimits = [
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "soft";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "hard";
          value = "99999";
        }
      ];
      services = {
        udev = {
          packages = [ pkgs.ffado ]; # If you have a FireWire audio interface
          extraRules = ''
            KERNEL=="rtc0", GROUP="audio"
            KERNEL=="hpet", GROUP="audio"
          '';
        };
        cron.enable = false;
      };
      environment.shellInit = ''
        export VST_PATH=/nix/var/nix/profiles/default/lib/vst:/var/run/current-system/sw/lib/vst:~/.vst
        export LXVST_PATH=/nix/var/nix/profiles/default/lib/lxvst:/var/run/current-system/sw/lib/lxvst:~/.lxvst
        export LADSPA_PATH=/nix/var/nix/profiles/default/lib/ladspa:/var/run/current-system/sw/lib/ladspa:~/.ladspa
        export LV2_PATH=/nix/var/nix/profiles/default/lib/lv2:/var/run/current-system/sw/lib/lv2:~/.lv2
        export DSSI_PATH=/nix/var/nix/profiles/default/lib/dssi:/var/run/current-system/sw/lib/dssi:~/.dssi
      '';
    })
  ];
}
