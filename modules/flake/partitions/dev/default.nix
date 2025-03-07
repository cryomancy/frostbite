{inputs, ...}: {
  systems = ["x86_64-linux"];

  imports = [
    inputs.devshell.flakeModule
    inputs.hercules-ci-effects.flakeModule
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    devshells.default = {
      name = "Kosei Development Shell";
      devshell.prj_root_fallback = {
        # Use the top-level directory of the working tree
        eval = "$(git rev-parse --show-toplevel)";
      };

      motd = ''
        {117}❄ Kosei Developement Shell ❄{reset}
        $(type -p menu &>/dev/null && menu)
      '';
      env = [
        {
          name = "IN_KOSEI_SHELL";
          value = 0;
        }
        {
          name = "NIX_CONFIG";
          value = "experimental-features = nix-command flakes pipe-operators repl-flake";
        }
      ];
      commands = [
        {
          name = "repl";
          category = "flake";
          command = ''
            repl
          '';
          help = "Enter this flake's REPL";
        }
      ];
      packages = [
        pkgs.typos
      ];
    };

    pre-commit = {
      settings = {
        addGcRoot = true;
        hooks = {
          alejandra.enable = true;
        };
      };
    };
  };
}
