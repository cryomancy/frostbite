_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.utils.cli;
in {
  options = {
    frostbite.utils.cli = {
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
      gh
      rclone
      gzip
      zip
      zstd
      just
      mkcert
      httpie
      any-nix-shell
      zig-shell-completions
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      bat = {
        enable = true;
      };
      broot = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      btop.enable = true;
      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      eza = {
        enable = true;
      };
      lsd = {
        enable = true;
        enableAliases = true;
      };
      ripgrep.enable = true;
      yazi.enable = true;
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };
    };
  };
}
