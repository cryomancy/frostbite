{
  self,
  inputs,
  ...
}: {
  systems = [
    "x86_64-linux"
  ];

  inputs = [
    inputs.git-hooks-nix
  ];

  perSystem = {
    pkgs,
    system,
    inputs',
    ...
  }: {
  };

  flake = {
  };
}
