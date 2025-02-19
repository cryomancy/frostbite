{inputs, ...}: {
  imports = [
    inputs.hercules-ci-effects.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];
}
