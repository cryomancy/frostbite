{
  self,
  inputs,
  ...
}: let
  projectRoot = self.outPath;
in {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      secset = pkgs.callPackage ./secset/default.nix {};
    };

    devshells.secset = {
      name = "Secset Development Shell";
      devshell.prj_root_fallback = {
        # Use the top-level directory of the working tree
        eval = "$(git rev-parse --show-toplevel)";
      };
      devshell.startup.default.text = "${config.pre-commit.installationScript}";

      motd = ''
        {117}❄ Secset Developement Shell ❄{reset}
        $(type -p menu &>/dev/null && menu)
      '';
      commands = [
        {
          name = "repl";
          category = "flake";
          command = ''
            nix repl --expr "builtins.getFlake \"$PWD\""
          '';
          help = "Enter this flake's REPL";
        }
        {
          name = "repair store";
          category = "flake";
          command = ''
            nix-collect-garbage -d && sudo nix-store --verify --check-contents --repair
          '';
          help = "Clean then repair the nix store";
        }
      ];
      packages = with pkgs; [
        typos
        ocamlPackages.ocaml
        ocamlPackages.dune_3
        ocamlPackages.findlib
        ocamlPackages.utop
        ocamlPackages.odoc
        ocamlPackages.ocaml-lsp
        ocamlformat
      ];
    };
  };
}
