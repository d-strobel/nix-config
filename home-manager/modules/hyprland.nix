{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = with pkgs; hyprland;
    portalPackage = with pkgs; xdg-desktop-portal-hyprland;
    systemd.enable = false;
    # Source extra temporary hyprland config for quick tests
    extraConfig = ''
      source = ${config.home.homeDirectory}/.config/hypr/hyprland-extra.conf
    '';
    settings = let
      # Home
      home = "${config.home.homeDirectory}";

      # Set SUPER as main modifier
      mainMod = "SUPER";
      menu = "${rofi} -show drun";

      # Packages
      rofi = "${pkgs.rofi}/bin/rofi";
      hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
      grim = "${pkgs.grim}/bin/grim";
      slurp = "${pkgs.slurp}/bin/slurp";
      satty = "${pkgs.satty}/bin/satty";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
    in {
      monitor = [
        ",preferred,auto,1"
        # 3 monitor home setup
        "desc:BNQ BenQ RL2460H S2G01438SL0, 1920x1080@60, 0x0, 1"
        "desc:Acer Technologies XB253Q TH5EE00B8521, 1920x1080@60, 1920x0, 1"
        "desc:BNQ BenQ RL2460H J7F06731SL0, 1920x1080@60, 3840x0, 1"
      ];

      device = [
        {
          # Disable notebook touchscreen
          name = "elan-touchscreen";
          enabled = false;
        }
        {
          # Change mouse sensitivity
          name = "pixart-dell-ms116-usb-optical-mouse";
          sensitivity = -0.8;
        }
        {
          # Change mouse sensitivity
          name = "benq-zowie-benq-zowie-gaming-mouse";
          sensitivity = -0.7;
        }
      ];

      exec-once = [
        "systemctl --user start waybar"
        "systemctl --user start hyprpolkitagent"
        "systemctl --user start wl-clip-persist"
      ];

      env = [
        # Hint Electron apps to use Wayland
        "NIXOS_OZONE_WL,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_QPA_PLATFORM,wayland"
        "XCURSOR_SIZE,${toString config.home.pointerCursor.size}"
        "XCURSOR_THEME,${config.home.pointerCursor.name}"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(d916fcee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 4;
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = false;
        };

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
        };
      };

      animations = {
        enabled = false;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "de";
        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      bind = [
        # General keybinds
        "${mainMod} shift, Q, killactive,"
        "${mainMod} shift, M, exit,"
        "${mainMod} shift, F, fullscreen,"
        "${mainMod} shift, T, togglesplit,"
        "${mainMod} shift, O, togglefloating,"
        "${mainMod}, SPACE, exec, ${menu}"
        "${mainMod} shift, Return, exec, ${hyprlock}"

        # Screenshot
        "${mainMod}, Print, exec, ${grim} -g \"$(${slurp})\" -t ppm - | ${satty} --filename - --fullscreen --output-filename ${home}/Pictures/Screenshots/$(date '+%Y%m%d-%H:%M:%S').png"

        # Window management
        "${mainMod}, h, movefocus, l"
        "${mainMod}, l, movefocus, r"
        "${mainMod}, k, movefocus, u"
        "${mainMod}, j, movefocus, d"
        "${mainMod} SHIFT, h, movewindow, l"
        "${mainMod} SHIFT, l, movewindow, r"
        "${mainMod} SHIFT, k, movewindow, u"
        "${mainMod} SHIFT, j, movewindow, d"
        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"
        "${mainMod} SHIFT, 1, movetoworkspace, 1"
        "${mainMod} SHIFT, 2, movetoworkspace, 2"
        "${mainMod} SHIFT, 3, movetoworkspace, 3"
        "${mainMod} SHIFT, 4, movetoworkspace, 4"
        "${mainMod} SHIFT, 5, movetoworkspace, 5"
        "${mainMod} SHIFT, 6, movetoworkspace, 6"
        "${mainMod} SHIFT, 7, movetoworkspace, 7"
        "${mainMod} SHIFT, 8, movetoworkspace, 8"
        "${mainMod} SHIFT, 9, movetoworkspace, 9"
      ];

      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, ${brightnessctl} s 5%+"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} s 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, ${playerctl} next"
        ", XF86AudioPause, exec, ${playerctl} play-pause"
        ", XF86AudioPlay, exec, ${playerctl} play-pause"
        ", XF86AudioPrev, exec, ${playerctl} previous"
      ];

      layerrule = [
        # Enable notifications blur
        "blur, notifications"
        "ignorezero, notifications"

        # Enable waybar blur
        "blur, waybar"
        "blurpopups, waybar"
        "ignorezero, waybar"

        # Blur logout overlay
        "blur, logout_dialog"
      ];

      workspace = [
        # "Smart gaps" / "No gaps when only"
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      windowrulev2 = [
        # Suppress maximize requests from applications
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # Fix XWaylandBridge for Screensharing
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"

        # Librewolf Picture-in-Picture
        "keepaspectratio,class:^(librewolf)$,title:^(Picture-in-Picture)$"
        "noborder,class:^(librewolf)$,title:^(Picture-in-Picture)$"
        "pin,class:^(librewolf)$,title:^(Picture-in-Picture)$"
        "float,class:^(librewolf)$,title:^(Picture-in-Picture)$"
        "pin,class:^(librewolf)$,title:^(Librewolf)$"
        "float,class:^(librewolf)$,title:^(Librewolf)$"

        # Change border color for SSH sessions
        "bordercolor rgba(f9164fee) rgba(f9f616ee) 45deg,title:^ssh.*"
        # Change border color for Remmina sessions
        "bordercolor rgba(f9164fee) rgba(f9f616ee) 45deg,class:^(org.remmina.Remmina)$,initialTitle:^(Remmina)$"

        # Hide screen share windows
        "workspace special:hidden silent,title:^discord\.com is sharing (your screen|a window)\."
        "workspace special:hidden silent,title:^teams\.microsoft\.com is sharing (your screen|a window)\."

        # "Smart gaps" / "No gaps when only"
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"

        # No blur for following applications
        "noblur, class:^lirewolf$"
        "noblur 3,class:^org\.remmina\.Remmina$"
        "noblur, class:^chromium-browser$"
        "noblur,class:^.*-winbox64.exe$"

        # Start applications in specific workspaces
        "workspace 3,class:^org\.remmina\.Remmina$"

        # Start winbox in tiling mode
        "tile,class:^.*-winbox64.exe$"
      ];
    };
  };
}
