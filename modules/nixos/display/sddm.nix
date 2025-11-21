_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.display.dm;
in {
  options = {
    frostbite.display.dm = lib.mkOption {
      default = true;
    };
  };

  config = {
    environment.systemPackages = [
      pkgs.hyde
      pkgs.Bibata-Modern-Ice
      pkgs.sddm-astronaut
    ];

    # Add this section to ensure cursor theme is properly loaded
    environment.sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
    };

    services.displayManager.sddm = {
      enable = true;
      theme = "sddm-astronaut-theme";
      wayland = {
        enable = true;
      };
      extraPackages = with pkgs.kdePackages; [
        qtsvg
        qtmultimedia
        qtvirtualkeyboard
      ];
      settings = {
        Theme = {
          CursorTheme = "Bibata-Modern-Ice";
          CursorSize = "24";
        };
        General = {
          # Set default session globally
          DefaultSession = "hyprland.desktop";
        };
        Wayland = {
          EnableHiDPI = true;
        };
      };
    };
  };
}
