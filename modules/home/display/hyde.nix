_:
{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.display.hyde;
in
{
  options = {
    frostbite.display.hyde = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  imports = [ inputs.hyde.homeModules.default ];

  config = lib.mkIf cfg.enable {
    hydenix = {
      # home-manager hydenix options
      hm = {
        enable = true; # enable home-manager module
        comma.enable = true; # useful nix tool to run software without installing it first
        dolphin.enable = true; # file manager
        editors = {
          enable = false; # enable editors module
          neovim = true; # enable neovim module
          vscode = {
            enable = true; # enable vscode module
            wallbash = true; # enable wallbash extension for vscode
          };
          vim.enable = false; # enable vim module
          default = "code"; # default text editor
        };
        fastfetch.enable = false; # fastfetch configuration
        firefox.enable = false; # enable firefox module
        git.enable = false;
        hyde.enable = true; # enable hyde module
        hyprland = {
          enable = true; # enable hyprland module
          extraConfig = ""; # extra config appended to userprefs.conf
          overrideMain = true; # complete override of hyprland.conf
          suppressWarnings = true; # suppress warnings
          # Animation configurations
          animations = {
            enable = true; # enable animation configurations
            preset = "standard"; # string from override or default: "standard" # or "LimeFrenzy", "classic", "diablo-1", "diablo-2", "disable", "dynamic", "end4", "fast", "high", "ja", "me-1", "me-2", "minimal-1", "minimal-2", "moving", "optimized", "standard", "vertical"
            extraConfig = ""; # additional animation configuration
            overrides = { }; # override specific animation files by name
          };
          # Shader configurations
          shaders = {
            enable = true; # enable shader configurations
            active = "disable"; # string from override or default: "disable" # or "blue-light-filter", "color-vision", "custom", "grayscale", "invert-colors", "oled", "oled-saver", "paper", "vibrance", "wallbash"
            overrides = { }; # override or add custom shaders
          };
          # Workflow configurations
          workflows = {
            enable = true; # enable workflow configurations
            active = "default"; # string from override or default: "default" # or "editing", "gaming", "powersaver", "snappy"
            overrides = { }; # override or add custom workflows
          };
          # Hypridle configurations
          hypridle = {
            enable = true; # enable hypridle configurations
            extraConfig = ""; # additional hypridle configuration
            overrideConfig = null; # complete hypridle configuration override (null or lib.types.lines)
          };
          # Keybindings configurations
          keybindings = {
            enable = true; # enable keybindings configurations
            extraConfig = ""; # additional keybindings configuration
            overrideConfig = null; # complete keybindings configuration override (null or lib.types.lines)
          };
          # Window rules configurations
          windowrules = {
            enable = true; # enable window rules configurations
            extraConfig = ""; # additional window rules configuration
            overrideConfig = null; # complete window rules configuration override (null or lib.types.lines)
          };
          # NVIDIA configurations
          nvidia = {
            enable = false; # enable NVIDIA configurations (defaults to config.hardware.nvidia.enabled)
            extraConfig = ""; # additional NVIDIA configuration
            overrideConfig = null; # complete NVIDIA configuration override (null or lib.types.lines)
          };
          # Pyprland configurations
          pyprland = {
            enable = true; # enable pyprland configurations
            extraConfig = ""; # additional pyprland configuration
            overrideConfig = null; # complete pyprland configuration override (null or lib.types.lines)
          };

          # Monitor configurations
          monitors = {
            enable = true; # enable monitor configurations
            overrideConfig = null; # complete monitor configuration override (null or lib.types.lines)
          };
        };
        lockscreen = {
          enable = true; # enable lockscreen module
          hyprlock = true; # enable hyprlock lockscreen
          swaylock = false; # enable swaylock lockscreen
        };
        notifications.enable = true; # enable notifications module
        qt.enable = true; # enable qt module
        rofi.enable = true; # enable rofi module
        screenshots = {
          enable = true; # enable screenshots module
          grim.enable = true; # enable grim screenshot tool
          slurp.enable = true; # enable slurp region selection tool
          satty.enable = false; # enable satty screenshot annotation tool
          swappy.enable = true; # enable swappy screenshot editor
        };
        wallpapers.enable = false; # enable wallpapers module
        shell = {
          enable = true; # enable shell module
          zsh = {
            enable = true; # enable zsh shell
            plugins = [ "sudo" ]; # zsh plugins
            configText = ""; # zsh config text
          };
          bash.enable = false; # enable bash shell
          fish.enable = false; # enable fish shell
          pokego.enable = false; # enable Pokemon ASCII art scripts
          p10k.enable = false; # enable p10k prompt
          starship.enable = true; # enable starship prompt
        };
        social = {
          enable = false; # enable social module
          discord.enable = false; # enable discord module
          vesktop.enable = false; # enable vesktop module
        };
        spotify.enable = false; # enable spotify module
        swww.enable = true; # enable swww wallpaper daemon
        terminals = {
          enable = true; # enable terminals module
          kitty = {
            enable = true; # enable kitty terminal
            configText = ""; # kitty config text
          };
        };
        theme = {
          enable = true; # enable theme module
          active = "Catppuccin Mocha"; # active theme name
          themes = [
            "1-Bit"
            "Abyssal-Wave"
            "AbyssGreen"
            "Amethyst-Aura"
            "AncientAliens"
            "Another World"
            "Bad Blood"
            "BlueSky"
            "Breezy Autumn"
            "Cat Latte"
            "Catppuccin Latte"
            "Catppuccin-Macchiato"
            "Catppuccin Mocha"
            "Code Garden"
            "Cosmic Blue"
            "Crimson Blade"
            "Crimson-Blue"
            "Decay Green"
            "DoomBringers"
            "Dracula"
            "Edge Runner"
            "Electra"
            "Eternal Arctic"
            "Ever Blushing"
            "Frosted Glass"
            "Graphite Mono"
            "Green Lush"
            "Greenify"
            "Grukai"
            "Gruvbox Retro"
            "Hack the Box"
            "Ice Age"
            "Joker"
            "LimeFrenzy"
            "Mac OS"
            "Material Sakura"
            "Monokai"
            "Monterey Frost"
            "Moonlight"
            "Nightbrew"
            "Nordic Blue"
            "Obsidian-Purple"
            "One Dark"
            "Oxo Carbon"
            "Paranoid Sweet"
            "Peace Of Mind"
            "Pixel Dream"
            "Rain Dark"
            "Red Stone"
            "Rosé Pine"
            "Scarlet Night"
            "Sci-fi"
            "Solarized Dark"
            "Synth Wave"
            "Timeless Dream"
            "Tokyo Night"
            "Tundra"
            "Vanta Black"
            "Windows 11"
          ];
        };
        waybar = {
          enable = true; # enable waybar module
          userStyle = ""; # custom waybar user-style.css
        };
        wlogout.enable = true; # enable wlogout module
        xdg.enable = true; # enable xdg module
      };
    };
  };
}
