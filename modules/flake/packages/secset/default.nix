{ocamlPackages, ...}:
ocamlPackages.buildDunePackage {
  pname = "secset";
  version = "0.0.1";
  duneVersion = "3.17";
  src = ./src;

  buildInputs = with ocamlPackages; [
    curses
  ];

  strictDeps = true;
}
