scoped: {
  config,
  inputs,
  lib,
  system,
  ...
}: let
  cfg = config.kosei.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
in {
  options = {
    kosei.spicetify = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        fullAppDisplay
        shuffle
        hidePodcasts
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
