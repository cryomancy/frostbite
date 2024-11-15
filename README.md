# 冬の構成

This repository contains a modular NixOS configuration designed to support multiple machines with profile support distributed across those machines.

## Directory Structure

- **`flake.nix`**: The main entry point for the NixOS configurations.
- **`lib`**: Custom library of Nix functions.
- **`modules`**: Contains reusable modules for both nixos and home-manager.
- **`outputs`**: Literally the flake outputs, although it aggregrates through a series of many function calls.
- **`secrets`**: Secures storage for sensitive information (e.g., API keys, passwords).
- **`vars`**: Defined variables to be passed around through modules (e.g. users).
- **`.sops.yaml`**: SOPS-NIX configuration
- **`LICENSE`**: A standard MIT License for ease of distribution and modification.
- **`README.md`**: This file, which provides an overview of the repository.

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/TahlonBrahic/nix-config.git .
```

2. Define your own configuration in outputs or choose a pre-defined configuration:

If you choose to use an already established configuration it is important to define your hardware specifications as either or a module or vars.

3. Rebuild your system:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Replace `hostname` with the appropriate hostname configured in ./outputs/architecture/src/hostname.nix

## References

The following websites and/or content creators were the most influential in the help of the developement of this NixOS repository and my understanding of both NixOS and its language:

### Websites:

[nix.dev](https://nix.dev/tutorials/nix-language)

### Repositories

[librephoenix](https://github.com/librephoenix/nixos-config)
[Misterio77](https://github.com/Misterio77/nix-config)
[ryan4yin](https://github.com/ryan4yin/nix-config)
[EmergentMind](https://github.com/EmergentMind/nix-config)
