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
        modules-right = ["pulseaudio" "battery" "clock"];

        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          persistent-workspaces = {
            "*" = 9;
          };
        };

        "hyprland/window" = {
          format = "{class}";
        };

        "pulseaudio" = {
          format = "VOL {volume}%";
          format-bluetooth = "VOL {volume}% ";
          format-muted = "MUTE 0%";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" ""];
          };
          on-click = "pavucontrol";
        };

        "battery" = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "BAT {capacity}%";
          format-charging = "BAT Loading {capacity}%";
          # format-alt = "{time} {icon}";
          # format-icons = ["" "" "" "" ""];
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
        };
      };
    };
  };
}
