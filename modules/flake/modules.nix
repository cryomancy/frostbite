{
  self,
  inputs,
  ...
}: {
  flake = {
    modules = {
      flake =
        self.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ../flake;
        };
      nixos =
        self.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ../nixos;
        };
      homeManager =
        self.lib.loadModulesRecursively
        {
          inherit inputs;
          src = ../home;
        };
    };
  };
}
