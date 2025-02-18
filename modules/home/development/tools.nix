scoped: {
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.kosei.tools;
in {
  options = {
    kosei.tools.enable = lib.mkOption {
      default = true;
      example = false;
      description = "dev tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gh
      just
      rustup
      cargo-cache
      cargo-expand
      mkcert
      httpie
      ansible
      tree-sitter
      any-nix-shell
      zig
      zg-shell-completions

      # Formatters and Linters
      alejandra
      deadnix
      nodePackages.prettier
      shellcheck
      shfmt
      statix

      # Encryption
      age
      sops
      rclone

      # Archival
      gzip
      zip
      zstd
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
