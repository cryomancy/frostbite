_: {
  config,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    apps = {
      generateAgeKey = {
        program = config.flake.lib.generateAgeKey {inherit pkgs;};
      };
      #makeIso = {
      #  program =
      #    config.flake.lib.makeIso {inherit inputs;};
      #};
      partitionDisk = {
        program = config.lib.partitionDisk {inherit pkgs;};
      };
      yubikeyInit = {
        program = config.lib.yubikeyInit {inherit pkgs;};
      };
      yubikeyTest = {
        program = config.lib.yubikeyTest {inherit pkgs;};
      };
      viewInputs = {
        program = config.lib.viewInputs {inherit pkgs;};
      };
    };
  };
}
