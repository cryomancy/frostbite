_: {
  inputs,
  outPath,
}: let
  system = "x86_64-linux";
  extraModules = [
    ./_home.nix
    ./_configuration.nix
    ./_hardware-configuration.nix
    ./_stage.nix
  ];
in
  inputs.frostbite.lib.systemTemplate {inherit extraModules system inputs outPath;}
