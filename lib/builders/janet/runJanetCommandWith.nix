_: {
  lib,
  stdenv,
  derivationArgs ? {},
  name,
}: buildCommand:
stdenv.mkDerivation ({
    enableParallelBuilding = true;
    inherit buildCommand name;
    passAsFile =
      ["buildCommand"]
      ++ (derivationArgs.passAsFile or []);
  }
  // lib.optionalAttrs (! derivationArgs ? meta) {
    pos = let
      args = builtins.attrNames derivationArgs;
    in
      if builtins.length args > 0
      then builtins.unsafeGetAttrPos (builtins.head args) derivationArgs
      else null;
  }
  // builtins.removeAttrs derivationArgs ["passAsFile"])
