{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
    inputs.hercules-ci-effects.flakeModule
  ];

  perSystem = {inputs', ...}: {
    formatter = inputs'.nixpkgs.legacyPackages.alejandra;
  };
}
