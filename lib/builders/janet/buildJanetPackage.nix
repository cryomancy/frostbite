{
  lib,
  stdenv,
  janet,
  jpm,
  ...
}: {
  pname,
  version,
  nativeBuildInputs ? [],
  minimumJanetVersion ? null,
  createDestdir ? true,
  dontStrip ? true,
  ...
} @ args:
if args ? minimumJanetVersion && lib.versionOlder janet.version args.minimumJanetVersion
then throw "${pname}-${version} is not available for Janet ${janet.version}"
else
  stdenv.mkDerivation (
    args
    // {
      name = "janet-${pname}-${version}";

      nativeBuildInputs = [janet jpm] ++ nativeBuildInputs;

      inherit createDestdir;
      inherit dontStrip;

      strictDeps = true;

      buildPhase = ''
        runHook preBuild
        echo "Building Janet package ${pname}-${version}..."
        ${janet}/bin/janet -k
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out

        cp -r * $out/

        runHook postInstall
      '';
    }
  )
