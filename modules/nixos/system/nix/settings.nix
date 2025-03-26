scoped: {
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.nixSettings;
in {
  options = {
    kosei.nixSettings = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  imports = [
    inputs.nur.modules.nixos.default
  ];

  config = lib.mkIf cfg.enable {
    nix = {
      channel.enable = false;
      settings = {
        accept-flake-config = true;
        allow-unsafe-native-code-during-evaluation = true;
        auto-optimise-store = true;
        commit-lock-file-summary = "update lock file";
        experimental-features = ["nix-command" "flakes" "pipe-operators"];
        # NOTE/TODO: This needs more testing, it causes a lot of issues
        # pure-eval = true;
        substituters = [
          "https://cache.nixos.org/"
          "https://fuyu-no-hokan.cachix.org"
          "https://nix-community.cachix.org"
          "https://rycee.cachix.org"
        ];
        trusted-users = ["@wheel"];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "fuyu-no-hokan.cachix.org-1:gW/kI695uo/nTD+nyqpbjZFcfK2dS6N2kAtHDrNYM+g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
        ];
        use-xdg-base-directories = true;
        warn-dirty = false;
      };
      registry = {
        nixpkgs = {
          flake = inputs.nixpkgs;
        };
      };
      nixPath = [
        "nixpkgs=${inputs.nixpkgs.outPath}"
      ];
      gc = {
        automatic = true;
        options = "--delete-older-than 14d";
      };
      package = pkgs.nixVersions.stable;
    };

    # OOM configuration:
    systemd = {
      # Create a separate slice for nix-daemon that is
      # memory-managed by the userspace systemd-oomd killer
      slices."nix-daemon".sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "50%";
      };
      services."nix-daemon".serviceConfig.Slice = "nix-daemon.slice";

      # If a kernel-level OOM event does occur anyway,
      # strongly prefer killing nix-daemon child processes
      services."nix-daemon".serviceConfig.OOMScoreAdjust = 1000;
    };
    # Move temporary Nix-Daemon files to disk while packaging
    # TODO: Add option for this for high memory systems
    environment.variables.NIX_REMOTE = "daemon";
    systemd.services.nix-daemon = {
      environment = {
        # Location for temporary files
        TMPDIR = "/var/cache/nix";
      };
      serviceConfig = {
        # Create /var/cache/nix automatically on Nix Daemon start
        CacheDirectory = "nix";
      };
    };
  };
}
