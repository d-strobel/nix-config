#!/run/current-system/sw/bin/bash

set +e

# For screen record / sharing
# See: https://github.com/DreamMaoMao/mangowc/wiki#screen-record-or-shareobs-or-wemeet
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots

# Start waybar (Status Bar)
waybar &

# Keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 &

# Clipboard content manager
wl-paste --type text --watch cliphist store &

# Notifications
dunst &
