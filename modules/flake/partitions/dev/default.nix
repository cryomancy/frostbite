{inputs, ...}: {
  systems = ["x86_64-linux"];
  imports = [
    inputs.devshell.flakeModule
    inputs.hercules-ci-effects.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem = {...}: {
    devshells.default = {
      commands = [
        {
          name = "greet";
          command = ''
            printf -- 'Hello, %s!\n' "''${1:-world}"
          '';
        }
      ];
    };
  };
}
