_:
{
  config,
  inputs,
  lib,
  pkgs,
  nixosConfig,
  ...
}:
let
  cfg = config.frostbite.display.hyprland;
  gamemode = inputs.frostbite.lib.hyprlandGameMode { inherit config lib pkgs; };
  onMonitorAttached = inputs.frostbite.lib.onMonitorAttached { inherit lib pkgs; };
  onMonitorDetached = inputs.frostbite.lib.onMonitorDetached { inherit lib pkgs; };
in
{
  options = {
    frostbite.display.hyprland = {
      enable = lib.mkEnableOption "hyprland";

      autostartWorkspaces = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
      };

      gamemode = {
        startscript = lib.mkOption {
          type = lib.types.string;
          default = gamemode "start";
        };
        endscript = lib.mkOption {
          type = lib.types.string;
          default = gamemode "stop";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = false;

      plugins = with pkgs.hyprlandPlugins; [
        #hyprbars
      ];

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

      settings = {
        animations = {
          enabled = true;

          animation = [
            # "windows, 1, 6, wind, slide"
            # "windowsIn, 1, 6, winIn, slide"
            # "windowsOut, 1, 5, winOut, slide"
            # "windowsMove, 1, 5, wind, slide"
            # "border, 1, 1, liner"
            # "borderangle, 1, 30, liner, loop"
            # "fade, 1, 10, default"
            # "workspaces, 1, 5, wind"
            # "specialWorkspace, 1, 5, wind, slidevert"
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 0, 0, ease"
          ];

          bezier = [
            # "wind, 0.05, 0.9, 0.1, 1.05"
            # "winIn, 0.1, 1.1, 0.1, 1.1"
            # "winOut, 0.3, -0.3, 0, 1"
            # "liner, 1, 1, 1, 1"
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
        };

        env = [
          "NIXOS_OZONE_WL, 1"
          "MOZ_ENABLE_WAYLAND, 1"
          "MOZ_WEBRENDER, 1"
          "XDG_SESSION_TYPE, wayland"
          "WLR_NO_HARDWARE_CURSORS, 1"
          "WLR_RENDERER_ALLOW_SOFTWARE, 1"
          "XDG_DATA_DIRS,$XDG_DATA_DIRS:$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share"
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          "OZONE_PLATFORM,wayland"
          "GDK_BACKEND,wayland"
          "QT_QPA_PLATFORM,wayland"
          # "QT_STYLE_OVERRIDE,kvantum"
        ];

        exec-once =
          #''${(lib.getExe pkgs.hyprland-monitor-attached)} ${onMonitorAttached} ${onMonitorDetached}''
          #+ (lib.strings.optionalString config.frostbite.display.hyprland.waypaper.enable
          #  ''${(lib.getExe pkgs.waypaper)} --restore'')
          #+ (lib.strings.optionalString cfg.autostartWorkspaces ''[workspace 1 silent] ${(lib.getExe pkgs.firefox)}'');
          [
            "hyprsunset"
            "systemctl --user start hyprpolkitagent"
          ];

        exec = [ "pkill -SIGUSR2 waybar || waybar" ]; # Fixes duplicating waybar on rebuilds

        # Mouse binds
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];

        bindel = [
          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        bind =
          let
            pactl = lib.getExe' pkgs.pulseaudio "pactl";
            workspaces = [
              "0"
              "1"
              "2"
              "3"
              "4"
              "5"
              "6"
              "7"
              "8"
              "9"
            ];
            directions = rec {
              left = "l";
              right = "r";
              up = "u";
              down = "d";
              h = left;
              l = right;
              k = up;
              j = down;
            };
          in
          [
            "SUPER,t,exec,kitty"
            "SUPER,f,exec,firefox"
            "SUPER,q,killactive"
            "SUPER,a,exec, wofi --show drun --sort-order=alphabetical"
            "SUPER,o,togglefloating"
            "SUPER,s,togglespecialworkspace"
            "SUPER,g,togglegroup"
            "SUPER,w,fullscreen"
            "SUPER,l,exec,hyprlock"
            # Add something for suspend
            # Add something to show keybinds
            # Add something for bluetooth menu
            # Add something for wifi
            ''SUPER,p,exec,grim -g "$(slurp)" - | wl-copy && wl-paste > ~/pictures/screenshots''
          ]
          ++
            # Switch workspaces
            (map (n: "SUPER,${n},workspace,name:${n}") workspaces)
          ++
            # Move window to workspace
            (map (n: "SUPERSHIFT,${n},movetoworkspacesilent,name:${n}") workspaces)
          ++
            # Move focus
            (lib.mapAttrsToList (key: direction: "SUPER,${key},movefocus,${direction}") directions)
          ++ (lib.mapAttrsToList (
            key: direction: "SUPERCONTROL,${key},movewindoworgroup,${direction}"
          ) directions)
          ++
            # Scroll through existing workspaces
            [
              "SUPER,mouse_down,workspace,e+1"
              "SUPER,mouse_up,workspace,e-1"
            ];

        decoration = {
          rounding = 5;
          fullscreen_opacity = 1.0;

          blur = {
            enabled = true;
            size = 5;
            passes = 2;
            vibrancy = 0.1696;
          };

          shadow = {
            enabled = true;
            offset = "3 3";
            range = 30;
            render_power = 3;
            ignore_window = true;
            color = lib.mkForce "0x44000000";
            color_inactive = lib.mkForce "0x66000000";
          };
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          resize_on_border = true;
          extend_border_grab_area = 25;
          hover_icon_on_border = true;
          layout = "dwindle";

          # TODO
          # "col.active_border" = activeBorder;
          # "col.inactive_border" = inactiveBorder;
        };

        gestures = {
          workspace_swipe = true; # Docs say this is deprecated?
        };

        group = {
          groupbar = {
            render_titles = false;
          };
        };

        input = {
          follow_mouse = 1;
          mouse_refocus = false;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
          };
        };

        layerrule = [
          "blur, wofi"
          "blur, waybar"
        ];

        master = {
          new_status = "master";
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = false;
          vfr = true;
          vrr = 0;
        };

        source = [
          "~/.config/hypr/monitors.conf" # autoload monitors from nwg-displays
        ];

        windowrule = [
          "suppressevent maximize, class:.*"

          # Force chromium into a tile to deal with --app bug
          "tile, class:^(chromium)$"

          # Settings management
          # "float, class:^(org.pulseaudio.pavucontrol|blueberry.py)$"

          # Float Steam, fullscreen RetroArch
          "float, class:^(steam)$"
          "fullscreen, class:^(com.libretro.RetroArch)$"

          # Just dash of transparency
          "opacity 0.97 0.9, class:.*"
          # Normal chrome Youtube tabs
          "opacity 1 1, class:^(chromium|google-chrome|google-chrome-unstable)$, title:.*Youtube.*"
          "opacity 1 0.97, class:^(chromium|google-chrome|google-chrome-unstable)$"
          "opacity 0.97 0.9, initialClass:^(chrome-.*-Default)$ # web apps"
          "opacity 1 1, initialClass:^(chrome-youtube.*-Default)$ # Youtube"
          "opacity 1 1, class:^(zoom|vlc|org.kde.kdenlive|com.obsproject.Studio)$"
          "opacity 1 1, class:^(com.libretro.RetroArch|steam)$"

          # Fix some dragging issues with XWayland
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

          # Float in the middle for clipse clipboard manager
          "float, class:(clipse)"
          "size 622 652, class:(clipse)"
          "stayfocused, class:(clipse)"
        ];
      };

      xwayland.enable = true;
    };

    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/persist/${config.home.homeDirectory}".directories = [ ".config/hypr" ];
      };

      packages = with pkgs; [
        grim # screenshot functionality
        slurp # screenshot functionality
        wlogout # wayland logout menu
        wlr-randr # wayland output utility
        wlr-which-key # keymap manager
        wofi # gtk-based app launcher
        kitty # backup terminal
        rot8 # screen rotation daemon
        hyprland-monitor-attached
        hyprsunset
        clipse
        hyprpicker
        wl-kbptr
        wl-screenrec
        wl-mirror
        wineWowPackages.wayland
        swappy
        wev
        playerctl
        pavucontrol
      ];

      sessionVariables = {
        XDG_SESSION_TYPE = "wayland";
      };
    };

    services = {
      dunst.enable = true;
      gnome-keyring.enable = true;
      hyprpolkitagent.enable = true;
    };
  };
}
