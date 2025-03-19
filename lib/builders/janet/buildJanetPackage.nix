_: {
  lib,
  stdenv,
  janet,
  jpm,
}: {
  pname,
  version,
  derivationArgs ? {},
  nativeBuildInputs ? [],
  buildInputs ? [],
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

      inherit buildInputs;
      nativeBuildInputs = [janet jpm] ++ nativeBuildInputs;

      inherit createDestdir;
      inherit dontStrip;
      inherit derivationArgs;

      strictDeps = true;

      buildPhase = ''
        runHook preBuild
        echo "Building Janet package ${pname}-${version}..."
        ${janet}/bin/janet -c ${pname}.janet ${pname}.jimage
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
