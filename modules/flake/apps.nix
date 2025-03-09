{self, ...}: {
  perSystem = {pkgs, ...}: {
    apps = {
      generateAgeKey = {
        program = self.lib.generateAgeKey {inherit pkgs;};
      };
      makeIso = {
        program = self.lib.iso {inherit self;};
      };
      partitionDisk = {
        program = self.lib.partitionDisk {inherit pkgs;};
      };
      yubikeyInit = {
        program = self.lib.yubikeyInit {inherit pkgs;};
      };
      yubikeyTest = {
        program = self.lib.yubikeyTest {inherit pkgs;};
      };
      viewInputs = {
        program = self.lib.viewInputs {inherit pkgs;};
      };
    };
  };
}
