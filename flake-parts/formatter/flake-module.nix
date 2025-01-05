localFlake: {
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
