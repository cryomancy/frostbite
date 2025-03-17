{
  config,
  self,
  ...
}: {
  perSystem = {pkgs, ...}: {
    apps = {
      generateAgeKey = {
        program = config.flake.lib.generateAgeKey {inherit pkgs;};
      };
      nixosGenerate = {
        program = pkgs.writeShellApplication {
          name = "nixosGenerate";
          text = ''
            nix build --file ${(config.flake.lib.nixosGenerate
                {
                  preInputs = self.inputs;
                  inherit (config) flake;
                })
              .config
              .system
              .build
              .isoImage}
          '';
        };
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
