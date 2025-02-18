{
  lib,
  flake-parts-lib,
  ...
}: {
  options = {
    flake =
      flake-parts-lib.mkSubmoduleOption
      {
        lib = lib.mkOption {
          description = ''
            Custom functions used in Kosei modules that may be helpful in other places.
          '';
          type = lib.types.lazyAttrsOf lib.types.raw;
          default = {};
        };
      };
  };
}
