_: {
  inputs,
  config,
  ...
}: {
  perSystem = {
    system,
    pkgs',
    ...
  }: {
    packages = {
      secset = pkgs'.callPackage ./secset/default.nix {};
    };
  };
}
