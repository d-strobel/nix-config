{
  cfg,
  config,
  pkgs,
  lib,
  ...
}: let
  # Custom symlinking
  mkSymlinkAttrs = import ../../lib/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib; # same as: cfg.context.inputs.home-manager.lib.hm;
  };

  # Script for VPN detection
  vpnConnected =
    pkgs.writeShellScriptBin
    /*
    bash
    */
    "vpnConnected" ''
      # Get vpn interfaces
      interfaces=$(ip a | grep -oP '^\d+: (wg[0-9]+|ppp[0-9]+):' | awk '{print $2}' | sed 's/://')

      # Error if multiple vpns are active
      count=$(echo "$interfaces" | wc -l)
      if [ "$count" -gt 1 ]; then
          printf '{"text": "%s", "class": "warning"}\n' "$(echo "$interfaces" | paste -sd'|' -)"
      elif [ "$count" -eq 1 ]; then
          printf '{"text": "%s", "class": "success"}\n' "$interfaces"
      fi
    '';
in {
  home.file = mkSymlinkAttrs {
    ".config/waybar/style.css" = {
      source = ../dotfiles/waybar/style.css;
      outOfStoreSymlink = true;
      recursive = false;
    };
  };

  programs.waybar = {
    enable = true;
    package = with pkgs; waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        modules-left = ["custom/nix" "hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["privacy" "custom/vpn" "memory" "cpu" "network" "pulseaudio" "backlight" "battery"];

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

        "custom/vpn" = {
          format = "󰖂 {text}";
          tooltip = false;
          hide-empty-text = true;
          exec = "${lib.getExe vpnConnected}";
          return-type = "json";
          interval = 15;
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
          format-wifi = "{icon} {signalStrength}%";
          format-ethernet = "󰈀 100%";
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
