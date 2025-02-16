<div>
  <img alt="NixOS Logo" src="https://github.com/NixOS/nixos-artwork/blob/master/logo/nix-snowflake-colours.svg" width="120px"/>
  <h1>❖ Winter Composition ❖</h1>
  <img src="https://img.shields.io/github/languages/code-size/TahlonBrahic/fuyu-no-kosei?style=for-the-badge&logoSize=auto&label=REPO%20SIZE&color=%23a5e8e9" alt="GitHub repo size"/>
  <img alt="Static Badge" src="https://img.shields.io/badge/%E5%86%AC%E3%81%AE%E6%A7%8B%E6%88%90-a5e8e9">
  <a href="https://nixos.org" target="_blank">
    <img src="https://img.shields.io/badge/NixOS-stable-blue.svg?style=for-the-badge&labelColor=1B2330&logo=NixOS&logoColor=white&color=ef65ea" alt="NixOS Stable"/>
  </a>
</div>

This repository contains a modular NixOS configuration designed to support multiple machines with profile support distributed across those machines.

## Directory Structure

- **`docs`**: Learn about the flake's API.
- **`flake.nix`**: The main entry point for the NixOS configurations.
- **`lib`**: Custom library of Nix functions.
- **`modules`**: Contains reusable modules for both nixos and home-manager.
- **`templates`**: Pre-built to quickly start using this flake.
- **`LICENSE`**: A standard MIT License for ease of distribution and modification.
- **`README.md`**: This file, which provides an overview of the repository.

## Getting Started

1. Choose your template:

```bash
$ nix --extra-experimental-features [ "nix-command flakes" ] flake init -t github:TahlonBrahic/multiple-systems
```

## References

The following websites and/or content creators were the most influential in the help of the developement of this NixOS repository and my understanding of both NixOS and its language:

### Websites:

[nix.dev](https://nix.dev/tutorials/nix-language)

### Repositories

[librephoenix](https://github.com/librephoenix/nixos-config)
[Misterio77](https://github.com/Misterio77/nix-config)
[Ryan Yin](https://github.com/ryan4yin/nix-config)
[EmergentMind](https://github.com/EmergentMind/nix-config)
[mwdavisii](https://github.com/mwdavisii/nyx/tree/main)
[Ludovico Piero](https://github.com/LudovicoPiero/dotfiles)
[Lan Tian](https://github.com/xddxdd/nixos-config)
[Liasicca](https://codeberg.org/Liassica/nixos-config)
[Max Mur](https://github.com/TheMaxMur/NixOS-Configuration)
[Frost-Phoenix](https://github.com/Frost-Phoenix/nixos-config)
[vimjoyer](https://github.com/vimjoyer/nixconf)

### Articles

["Stateless" Operating System](https://lantian.pub/en/article/modify-computer/nixos-impermanence.lantian/)

### Documentation

["nlewo NixOS Manual"](https://nlewo.github.io/nixos-manual-sphinx/index.html)
