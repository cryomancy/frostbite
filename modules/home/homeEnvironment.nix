{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.homeEnvironment;
in {
  options = {
    homeEnvironment.enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable the custom fuyu development environment.";
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

      # Language Servers
      nil

      # Formatters and Linters
      alejandra
      deadnix
      nodePackages.prettier
      shellcheck
      shfmt
      statix

      # Encryption
      age
      # TODO: Add option
      # age-plugin-yubikey
      sops
      rclone

      # Archival
      gzip
      zip
      zstd

      # Android
      adb-sync
      adbfs-rootless
      waydroid
      scrcpy # Display and control Android devices over USB or TCP/IP
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      broot = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      lsd = {
        enable = true;
        enableAliases = true;
      };
      starship = {
        enable = true;
        settings = {
          aws.disabled = true;
          gcloud.disabled = true;
          kubernetes.disabled = false;
          git_branch.style = "242";
          directory = {
            style = "blue";
            truncate_to_repo = false;
            truncation_length = 8;
          };
          python.disabled = true;
          ruby.disabled = true;
          hostname.ssh_only = false;
          hostname.style = "bold green";
        };
      };
      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };
    };
  };
}
