{
  config,
  self,
  ...
}: {
  config.flake.nixosConfigurations = {
    iso =
      config.flake.lib.nixosGenerate
      {
        preInputs = self.inputs;
        inherit (config) flake;
      };
  };
}
