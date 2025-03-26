_: {
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
    nixpkgs = lib.mkForce {
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      overlays =
        [
          (final: _prev: {
            stable = import inputs.nixpkgs-stable {
              inherit (final) system;
              config.allowUnfree = true;
            };
            master = import inputs.nixpkgs-master {
              inherit (final) system;
              config.allowUnfree = true;
            };
          })
        ]
        ++ [
          inputs.fuyuvim.overlays.default
          inputs.nur.overlays.default
        ];
    };
  };
}
