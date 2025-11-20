_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.utils.nix;
in
{
  options = {
    frostbite.utils.nix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    home.packages = with pkgs; [
      nix-du # Tool to determine which gc-roots take space in your nix store
      nix-init # Generate Nix packages from URLs
      nix-output-monitor # Generate additional information while building
      nix-tree # Interactively browse dependency graphs of Nix derivations
      nix-melt # Flake.lock viewer
      nix-doc # A tool leveraging the rnix Nix parser for intelligent documentation search and tags generation.
      nurl # Generate Nix fetcher calls from repository URLshttps://github.com/mwdavisii/nyx/tree/main
      nh # Nix helper
      comma # Quickly run any binary; wraps together nix run and nix-index.
      manix # A fast CLI documentation searcher for Nix.
    ];
  };
}
