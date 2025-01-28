scoped: lib: script: 
  lib.getExe script |> builtins.readFile |> lib.lists.toList |> builtins.exec
