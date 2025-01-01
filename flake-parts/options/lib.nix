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
      lib = mkOption {
        type = types.unspecified;
        default = {};
        description = ''
          An attribute set of per system functions.
        '';
      };
    };

    perSystem = mkPerSystemOption {
      _file = ./lib.nix;
      options = {
        lib = mkOption {
          type = types.unspecified;
          default = {};
          description = ''
            A attribute set of functions.
          '';
        };
      };
    };
  };
  config = {
    flake.lib =
      mapAttrs
      (k: v: v.lib)
      (
        filterAttrs
        (k: v: v.lib != null)
        config.allSystems
      );

    perInput = system: flake:
      optionalAttrs (flake ? lib.${system}) {
        lib = flake.lib.${system};
      };
  };
}
