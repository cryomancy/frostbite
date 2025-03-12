localFlake: {inputs, ...}: {
  perSystem = {pkgs, ...}: {
    apps = {
      generateAgeKey = {
        program = localFlake.lib.generateAgeKey {inherit pkgs;};
      };
      #makeIso = {
      #  program = localFlake.lib.makeIso {inherit inputs;};
      #};
      partitionDisk = {
        program = localFlake.lib.partitionDisk {inherit pkgs;};
      };
      yubikeyInit = {
        program = localFlake.lib.yubikeyInit {inherit pkgs;};
      };
      yubikeyTest = {
        program = localFlake.lib.yubikeyTest {inherit pkgs;};
      };
      viewInputs = {
        program = localFlake.lib.viewInputs {inherit pkgs;};
      };
    };
  };
}
