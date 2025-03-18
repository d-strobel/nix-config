{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    package = with pkgs; waybar;
    style = ../dotfiles/waybar/style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["custom/nix" "image" "hyprland/workspaces"];
        modules-right = ["privacy" "memory" "cpu" "disk" "network" "pulseaudio" "backlight" "battery" "clock"];

        # Left side
        "custom/nix" = {
          on-click = "wlogout";
          format = " ";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;
          persistent-workspaces = {
            "*" = 9;
          };
        };

        # Right side
        "privacy" = {
          icon-spacing = 4;
          icon-size = 18;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
        };

        "memory" = {
          interval = 15;
          format = "  {percentage}%   {swapPercentage}%";
        };

        "cpu" = {
          interval = 5;
          format = "{icon} {usage}%";
          format-icons = [" "];
        };

        "disk" = {
          path = "/";
          format = "root: {free}";
          unit = "GB";
        };

        "network" = {
          on-click = "nm-connection-editor";
          format-wifi = "{icon} {ipaddr}";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰤮 down";
          format-icons = ["󰤯 " "󰤟 " "󰤢 " "󰤨 "];
          tooltip-format-wifi = ''
            SSID: {essid} ({signalStrength}%)
            Interface: {ifname}
            Address: {ipaddr}/{cidr}
            Gateway: {gwaddr}
          '';
          tooltip-format-ethernet = ''
            Interface: {ifname}
            Address: {ipaddr}/{cidr}
            Gateway: {gwaddr}
          '';
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
        };

        "pulseaudio" = {
          format = "{format_source} {icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "{format_source}  0%";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭 0%";
          on-click = "pavucontrol";
          format-icons = ["" "" " "];
        };

        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = ["󰹐 " "󱩎 " "󱩏 " "󱩐 " "󱩑 " "󱩒 " "󱩓 " "󱩔 " "󱩕 " "󱩖 " "󰛨 "];
        };

        "battery" = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = ["󱉞" "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          tooltip = true;
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
      };
    };
  };

  systemd.user.services = let
    waybar = "${pkgs.waybar}/bin/waybar";
  in {
    waybar = {
      Unit = {
        Description = "Wayland status bar.";
        Documentation = "https://github.com/Alexays/Waybar";
        Requires = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${waybar}";
        ExecStop = "pgrep waybar && pkill waybar";
        Type = "simple";
        Restart = "on-failure";
      };
    };
  };
}
