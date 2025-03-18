{
  lib,
  stdenv,
  stdenvNoCC,
}: rec {
  runJanetCommand = name: env:
    runJanetCommandWith {
      stdenv = stdenvNoCC;
      runLocal = false;
      inherit name;
      derivationArgs = env;
    };
  runJanetCommandWith = let
    # prevent infinite recursion for the default stdenv value
    defaultStdenv = stdenv;
  in
    {
      # which stdenv to use, defaults to a stdenv with a C compiler, pkgs.stdenv
      stdenv ? defaultStdenv,
      # extra arguments to pass to stdenv.mkDerivation
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
        // builtins.removeAttrs derivationArgs ["passAsFile"]);
}
