_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.defaultPrograms;
in
{
  options = {
    frostbite.defaultPrograms = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zsh.enable = true;
      dconf.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    environment.systemPackages = with pkgs; [
      parallel # Shell tool for executing jobs in parallel
      jq # Command-line JSON processor
      imagemagick # Image manipulation tools
      resvg # SVG rendering library and tools
      libnotify # Desktop notification library
      envsubst # Environment variable substitution utility
      killall # Process termination utility
      wl-clipboard # Wayland clipboard utilities
      wl-clip-persist # Keep Wayland clipboard even after programs close (avoids crashes)
      gnumake # Build automation tool
      git # distributed version control system
      fzf # command line fuzzy finder
      polkit_gnome # authentication agent for privilege escalation
      dbus # inter-process communication daemon
      upower # power management/battery status daemon
      mesa # OpenGL implementation and GPU drivers
      dconf # configuration storage system
      dconf-editor # dconf editor
      home-manager # user environment manager
      xdg-utils # Collection of XDG desktop integration tools
      desktop-file-utils # for updating desktop database
      hicolor-icon-theme # Base fallback icon theme
      kdePackages.ark # kde file archiver
      cava # audio visualizer
      cliphist # clipboard manager
      wayland # for wayland support
      egl-wayland # for wayland support
      xwayland # for x11 support
      gobject-introspection # for python packages
      trash-cli # cli to manage trash files
      gawk # awk implementation
      coreutils # coreutils implementation
      bash-completion # Add bash-completion package
      brightnessctl # screen brightness control
      udiskie # manage removable media
      ntfs3g # ntfs support
      exfat # exFAT support
      libinput-gestures # actions touchpad gestures using libinput
      libinput # libinput library
      lm_sensors # system sensors
      pciutils # pci utils
      hypridle
    ];
  };
}
