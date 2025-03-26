_: {
  config,
  inputs,
  lib,
  system,
  ...
}: let
  cfg = config.frostbite.programs.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
in {
  options = {
    frostbite.programs.spicetify = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  imports = [inputs.spicetify-nix.homeManagerModules.spicetify];

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
