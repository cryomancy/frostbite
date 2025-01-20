
# `Home Manager Options`

## Browser

Kosei comes with five pre-configured browsers out of the box.
These are `chrome`, `chromium`, `firefox`, `librewolf`, and `lynx`.
The all plug into the design modules with Stylix thus integrating
with the rest of the ecosystem. They also have a few preconfigured
stylesheets to choose from to aid in furth customization. To enable
any of the pre-configured browsers add this to extraModules:

```nix
{
  home-manager.users."tahlon".kosei = {
    browser.firefox.enable = true;
  };
}

```
