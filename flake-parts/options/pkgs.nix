{
  config,
  lib,
  flake-parts-lib,
  ...
}: let
  inherit
    (lib)
    filterAttrs
    mapAttrs
    mkOption
    optionalAttrs
    types
    ;
  inherit
    (flake-parts-lib)
    mkSubmoduleOptions
    mkPerSystemOption
    ;
in {
  options = {
    flake = mkSubmoduleOptions {
      pkgs = mkOption {
        type = types.unspecified;
        default = {};
        description = ''
          An attribute set of all systems' nixpkgs merged with custom packages and overlays.
        '';
      };
    };

    perSystem = mkPerSystemOption {
      _file = ./pkgs.nix;
      options = {
        pkgs = mkOption {
          type = types.unspecified;
          default = {};
          description = ''
            A attribute set of nixpkgs merged with custom packages and overlays.
          '';
        };
      };
    };
  };
  config = {
    flake.pkgs =
      mapAttrs
      (k: v: v.pkgs)
      (
        filterAttrs
        (k: v: v.pkgs != null)
        config.allSystems
      );

    perInput = system: flake:
      optionalAttrs (flake ? lib.${system}) {
        pkgs = flake.pkgs.${system};
      };
  };
}
