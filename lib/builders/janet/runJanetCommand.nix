_: {
  lib,
  stdenv,
  stdenvNoCC,
  callPackage,
  inputs,
}: name: env:
callPackage inputs.frostbite.lib.runJanetCommandWith {
  stdenv = stdenvNoCC;
  inherit name;
  derivationArgs = env;
}
