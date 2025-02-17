scoped: {
  config,
  inputs,
  lib,
  system,
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

  imports = [
    inputs.nur.modules.nixos.default
  ];

  config = lib.mkIf cfg.enable {
    nixpkgs = {
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
