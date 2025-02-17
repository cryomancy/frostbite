scoped: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.kosei.nixpkgs;
in {
  options = {
    kosei.nixpkgs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      overlays =
        [
          (final: _prev: {
            stable = import inputs.nixpkgs-stable {inherit (final) system;};
            master = import inputs.nixpkgs-master {inherit (final) system;};
          })
        ]
        ++ [
          inputs.fuyuvim.overlays.default
          inputs.nur.overlays.default
        ];
    };
  };
}
