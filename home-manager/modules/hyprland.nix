{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = with pkgs; hyprland;
    systemd.enable = false;
    settings = let
      # Home
      home = "${config.home.homeDirectory}";

      # Set SUPER as main modifier
      mainMod = "SUPER";
      menu = "${tofi} | xargs hyprctl dispatch exec --";

      # Packages
      alacritty = "${pkgs.alacritty}/bin/alacritty";
      tofi = "${pkgs.tofi}/bin/tofi-drun";
      hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
      grim = "${pkgs.grim}/bin/grim";
      slurp = "${pkgs.slurp}/bin/slurp";
      satty = "${pkgs.satty}/bin/satty";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      playerctl = "${pkgs.playerctl}/bin/playerctl";
    in {
      monitor = ",preferred,auto,1";

      device = [
        {
          # Disable notebook touchscreen
          name = "elan-touchscreen";
          enabled = false;
        }
        {
          # Change mouse sensitivity
          name = "pixart-dell-ms116-usb-optical-mouse";
          sensitivity = -0.7;
        }
      ];

      exec-once = [
        "systemctl --user start waybar"
        "systemctl --user start hyprpolkitagent"
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
        gaps_in = 2;
        gaps_out = 2;
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
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
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
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
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
        workspace_swipe = true;
      };

      bind = [
        # General keybinds
        "${mainMod} shift, Q, killactive,"
        "${mainMod} shift, M, exit,"
        "${mainMod}, SPACE, exec, ${menu}"
        "${mainMod}, T, exec, ${alacritty}"
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
      ];

      windowrulev2 = [
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
        "workspace special:hidden silent,title:^discord\.com is sharing your screen\."
        "workspace special:hidden silent,title:^teams\.microsoft\.com is sharing your screen\."
      ];
    };
  };
}
