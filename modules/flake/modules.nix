{
  config,
  inputs,
  ...
}: {
  flake = {
    modules = {
      flake =
        config.flake.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ../flake;
        };
      nixos =
        config.flake.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ../nixos;
        };
      homeManager =
        config.flake.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ../home;
        };
      droid =
        config.flake.lib.loadModulesReursively
        {
          inherit inputs;
          src = ../droid;
        };
    };
  };
}
