_:
{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.frostbite.display.design;
  themes = {
    # Dark, vibrant Tokyo-inspired neon
    "tokyo-night" = {
      base16-theme = "tokyo-night-dark";
    };

    # Light variant of Tokyo Night
    "tokyo-night-light" = {
      base16-theme = "tokyo-night-light";
    };

    # Catppuccin: dark, smooth, chocolatey
    "catppuccin-mocha" = {
      base16-theme = "catppuccin-mocha";
    };

    # Catppuccin: bluish, refined, soft dark
    "catppuccin-macchiato" = {
      base16-theme = "catppuccin-macchiato";
    };

    # Catppuccin: pastel, medium contrast
    "catppuccin-frappe" = {
      base16-theme = "catppuccin-frappe";
    };

    # Catppuccin: light, creamy pastel
    "catppuccin-latte" = {
      base16-theme = "catppuccin-latte";
    };

    # Japanese ink painting aesthetic
    "kanagawa" = {
      base16-theme = "kanagawa";
    };

    # Forest green, warm, natural
    "everforest" = {
      base16-theme = "everforest";
    };

    # Arctic, icy, clean blue
    "nord" = {
      base16-theme = "nord";
    };

    # Gruvbox: high contrast, warm retro
    "gruvbox" = {
      base16-theme = "gruvbox-dark-hard";
    };

    # Gruvbox: softer dark variant
    "gruvbox-dark-soft" = {
      base16-theme = "gruvbox-dark-soft";
    };

    # Gruvbox: default balanced dark
    "gruvbox-dark-medium" = {
      base16-theme = "gruvbox-dark-medium";
    };

    # Gruvbox: warm, retro light mode
    "gruvbox-light" = {
      base16-theme = "gruvbox-light-medium";
    };

    # Solarized: famous balanced dark
    "solarized-dark" = {
      base16-theme = "solarized-dark";
    };

    # Solarized: warm low-contrast light mode
    "solarized-light" = {
      base16-theme = "solarized-light";
    };

    # One Dark: modern, saturated dark
    "onedark" = {
      base16-theme = "onedark";
    };

    # One Light: clean and slightly pastel
    "onelight" = {
      base16-theme = "onelight";
    };

    # Dracula: iconic purple neon dark
    "dracula" = {
      base16-theme = "dracula";
    };

    # Monokai: classic bright syntax colors
    "monokai" = {
      base16-theme = "monokai";
    };

    # Monokai Pro: polished paid variant
    "monokai-pro" = { };

    # Rosé Pine: soft, cozy twilight vibe
    "rose-pine" = {
      base16-theme = "rose-pine";
    };

    # Rosé Pine Moon: dreamy dark pastel
    "rose-pine-moon" = {
      base16-theme = "rose-pine-moon";
    };

    # Rosé Pine Dawn: soft warm light
    "rose-pine-dawn" = {
      base16-theme = "rose-pine-dawn";
    };

    # IBM’s Oxocarbon: deep charcoal dark
    "oxocarbon" = {
      base16-theme = "oxocarbon-dark";
    };

    # Oxocarbon light: modern grayscale light
    "oxocarbon-light" = {
      base16-theme = "oxocarbon-light";
    };

    # Material Darker: Google-style deep dark
    "material" = {
      base16-theme = "material-darker";
    };

    # Material Ocean: cool blue material dark
    "material-ocean" = {
      base16-theme = "material-ocean";
    };

    # Material Palenight: pastel/night hybrid
    "material-palenight" = {
      base16-theme = "material-palenight";
    };

    # Ayu: warm modern dark
    "ayu-dark" = {
      base16-theme = "ayu-dark";
    };

    # Ayu Mirage: muted dark pastel
    "ayu-mirage" = {
      base16-theme = "ayu-mirage";
    };

    # Ayu Light: bright and minimal
    "ayu-light" = {
      base16-theme = "ayu-light";
    };

    # Nightfox: rich contrast, modern
    "nightfox" = {
      base16-theme = "nightfox";
    };

    # Dawnfox: warm early morning light
    "dawnfox" = {
      base16-theme = "dawnfox";
    };

    # Dayfox: crisp, bright, readable
    "dayfox" = {
      base16-theme = "dayfox";
    };

    # Nordfox: Nord but more contrast
    "nordfox" = {
      base16-theme = "nordfox";
    };

    # Terafox: rustic earthy dark
    "terafox" = {
      base16-theme = "terafox";
    };

    # Carbonfox: almost-black modern
    "carbonfox" = {
      base16-theme = "carbonfox";
    };

    # Edge: soft cool dark
    "edge-dark" = {
      base16-theme = "edge-dark";
    };

    # Edge light: calm cool light
    "edge-light" = {
      base16-theme = "edge-light";
    };

    # Forest Night: deep green foresty
    "forest-night" = { };

    # Base16 default dark
    "base16-default-dark" = {
      base16-theme = "default-dark";
    };

    # Base16 default light
    "base16-default-light" = {
      base16-theme = "default-light";
    };

    # Papercolor: high-contrast light scheme
    "papercolor-light" = {
      base16-theme = "papercolor-light";
    };

    # Papercolor dark: bold and punchy
    "papercolor-dark" = {
      base16-theme = "papercolor-dark";
    };

    # Night Owl: blue/purple vibrant
    "night-owl" = {
      base16-theme = "night-owl";
    };

    # Gotham: extremely low contrast dark
    "gotham" = {
      base16-theme = "gotham";
    };

    # Tender: warm dark with muted hues
    "tender" = {
      base16-theme = "tender";
    };

    # Smoky: very muted hazy aesthetic
    "smoky" = { };

    # Palenight: pastel version of Material
    "palenight" = {
      base16-theme = "palenight";
    };

    # Tokyodark: deeper, punchier Tokyo theme
    "tokyodark" = {
      base16-theme = "tokyodark";
    };

    # Dracula Pro: premium variant of Dracula
    "dracula-pro" = { };

    # Moonfly: teal/green moody dark
    "moonfly" = { };

    # Nightfly: blue-heavy relaxed dark
    "nightfly" = { };

    # Oceanic Next: classic vibrant ocean blues
    "oceanic-next" = {
      base16-theme = "oceanic-next";
    };

    # Doom One: Emacs doom-inspired dark
    "doom-one" = { };

    # Doom Dracula: doom version of Dracula
    "doom-dracula" = { };

    # Doom Gruvbox: doom-style gruvbox
    "doom-gruvbox" = { };

    # Doom Nord: doom-style nord
    "doom-nord" = { };
  };
in
{
  options = {
    frostbite.display.design = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [ ".config/stylix" ];
      };
    };

    stylix = {
      enable = false;
      autoEnable = false;

      opacity = {
        applications = 0.85;
        desktop = 0.85;
        popups = 0.65;
        terminal = 0.65;
      };

      targets = {
        bat.enable = true;
        btop.enable = true;
        emacs.enable = true;
        firefox.enable = true;
        fish.enable = true;
        fzf.enable = true;
        gtk.enable = false;
        ghostty.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = false;
        kitty.enable = true;
        librewolf.enable = true;
        mangohud.enable = true;
        mako.enable = true;
        rofi.enable = true;
        vesktop.enable = true;
        vim.enable = true;
        waybar.enable = true;
        wofi.enable = true;
        zellij.enable = true;
      };
    };
  };
}
