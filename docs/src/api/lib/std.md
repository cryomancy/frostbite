# `executeScript`

Source: [`lib/executeScript.nix`](https://github.com/TahlonBrahic/kosei/blob/main/lib/load.nix)

Type: `script -> { ... }`

Arguments:

- `script` : `Package`

  A script built from a derivation such as pkgs.writeShellScriptBin .

For an expression such as this:

```nix
{pkgs, inputs, ...}:
let
  script = pkgs.writeShellScriptBin "echoScript"
    '' echo "hello" '';
in
  inputs.kosei.lib.executeScript script
```

The output will look like this:

```nix
"hello"
```

The use of this function enabled by experimental features in
the configuration was inspired by this
[forum post](https://discourse.nixos.org/t/memoize-result-of-builtins-exec/2028).
