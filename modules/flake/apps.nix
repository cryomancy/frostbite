{config, ...}: {
  perSystem = {pkgs, ...}: {
    apps = {
      generateAgeKey = {
        program = config.flake.lib.generateAgeKey {inherit pkgs;};
      };
      nixosGenerate = {
        program = config.flake.lib.generateKoseiISO {inherit pkgs;};
      };
      partitionDisk = {
        program = config.flake.lib.partitionDisk {inherit pkgs;};
      };
      yubikeyInit = {
        program = config.flake.lib.yubikeyInit {inherit pkgs;};
      };
      yubikeyTest = {
        program = config.flake.lib.yubikeyTest {inherit pkgs;};
      };
      viewInputs = {
        program = config.flake.lib.viewInputs {inherit pkgs;};
      };
    };
  };
}
