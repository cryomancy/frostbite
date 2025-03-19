_: {
  lib,
  stdenv,
  stdenvNoCC,
  callPackage,
  inputs,
}: name: env:
callPackage inputs.kosei.lib.runJanetCommandWith {
  stdenv = stdenvNoCC;
  inherit name;
  derivationArgs = env;
}
