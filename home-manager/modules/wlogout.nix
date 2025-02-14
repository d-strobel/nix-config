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
        action = "hyprlock & systemctl suspend";
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
    ];

    # style = ../dotfiles/wlogout/style.css;
  };
}
