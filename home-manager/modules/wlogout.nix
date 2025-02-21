{pkgs, ...}: {
  programs.wlogout = {
    enable = true;
    package = with pkgs; wlogout;

    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock screen";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "hyprlock & sleep 2s & systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "nightmode";
        action = "pgrep hyprsunset && pkill hyprsunset || hyprsunset --temperature 5500";
        text = "Nightmode";
        keybind = "n";
      }
    ];

    # style = ../dotfiles/wlogout/style.css;
  };
}
