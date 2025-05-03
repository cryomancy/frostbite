_: lib: script:
lib.pipe (lib.getExe script) [
  builtins.readFile
  lib.lists.toList
  builtins.exec
]
