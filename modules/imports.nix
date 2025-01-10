{
  haumea,
  lib,
  ...
}: {
  nixos = let
    localModules =
      haumea.lib.load
      {
        src = ./nixos;
        loader = haumea.lib.loaders.path;
      };
    nixStorePaths = builtins.attrValues localModules;
    modules = map (module:
      lib.path.subpath.join
      (lib.lists.sublist 4 7
        (lib.strings.splitString "/" module)))
    nixStorePaths;
  in {imports = modules;};
  home = let
    localModules =
      haumea.lib.load
      {
        src = ./home;
        loader = haumea.lib.loaders.path;
      };
    nixStorePaths = builtins.attrValues localModules;
    modules = map (module:
      lib.path.subpath.join
      (lib.lists.sublist 4 7
        (lib.strings.splitString "/" module)))
    nixStorePaths;
  in {imports = modules;};
}
