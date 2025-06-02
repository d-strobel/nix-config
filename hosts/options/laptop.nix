{...}: {
  # Laptop closing the lid:
  # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend", "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "suspend";
  # Do nothing when other monitors are plugged in.
  services.logind.lidSwitchDocked = "ignore";
}
