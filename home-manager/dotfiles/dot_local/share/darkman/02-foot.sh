#!/bin/sh

# Switch the foot terminal initial mode and sen SIGUSR to reload.

# Ignore SIGUSR1 and SIGUSR2 to prevent the script from terminating
trap '' USR1 USR2

case "$1" in
dark)
  pkill -USR1 foot
  ;;
light)
  pkill -USR2 foot
  ;;
default) exit 1 ;;
esac

mkdir -p ~/.local/state/foot/
echo "initial-color-theme=$1" > ~/.local/state/foot/colorscheme.ini
