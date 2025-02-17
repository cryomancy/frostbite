scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.cliUtils;
in {
  options = {
    kosei.cliUtils = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Essential utilities
      which # Locate a command
      vim # Text editor
      curl # Transfer data from or to a server
      tmux # Terminal multiplexer
      htop # Interactive process viewer
      killall # Kill processes by name
      findutils # Basic file search utilities
      ripgrep # Line-oriented search tool (faster than grep)
      fd # Simple, fast file search tool
      procs # Process viewer
      fx # Command-line JSON processor
      bottom # Resource monitor (alternative to htop)
      alchemy # Drawing application
      act # Run your Github actions locally
      just # Command runner with easy-to-write scripts
    ];
  };
}
