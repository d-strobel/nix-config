{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    package = with pkgs; hypridle;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session && sleep 2s";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          # 10 mins
          timeout = 600;
          on-timeout = "[ $(cat /sys/class/power_supply/AC/online) -eq 0 ] && brightnessctl --save set 15%";
          on-resume = "brightnessctl --restore";
        }
        {
          # 30 mins
          timeout = 1800;
          on-timeout = "[ $(cat /sys/class/power_supply/AC/online) -eq 0 ] && hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # 60 mins
          timeout = 3600;
          on-timeout = "[ $(cat /sys/class/power_supply/AC/online) -eq 0 ] && systemctl suspend";
        }
      ];
    };
  };
}
