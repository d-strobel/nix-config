{
  programs.waybar = {
    enable = true;
    style = ../dotfiles/waybar/style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["disk" "network" "pulseaudio" "battery" "clock"];

        # Left side
        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          persistent-workspaces = {
            "*" = 9;
          };
        };

        # Center
        "hyprland/window" = {
          format = "{class}";
          rewrite = {
            "(.*).ghostty" = "Ghostty";
            "(.*).Nautilus" = "Nautilus";
            "librewolf" = "Librewolf";
          };
        };

        # Right side
        "disk" = {
          path = "/";
          format = "root: {free}";
          unit = "GB";
        };

        "network" = {
          on-click = "nm-connection-editor";
          format-wifi = "W: {ipaddr} ({signalStrength}%)";
          format-ethernet = "E: {ipaddr}";
          format-disconnected = "NET down";
          tooltip-format =  "{ifname} via {gwaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };

        "pulseaudio" = {
          format = "VOL {volume}%";
          format-bluetooth = "VOL {volume}% ";
          format-muted = "MUTE 0%";
          on-click = "pavucontrol";
        };

        "battery" = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "BAT {capacity}%";
          format-charging = "BAT Loading {capacity}%";
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
        };
      };
    };
  };
}
