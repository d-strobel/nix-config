{
  imports = [
    ./hardware-configuration.nix
    ../defaults
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS encryption
  boot.initrd.luks.devices."luks-09b09896-1d5f-4f4e-98e0-120876ece499".device = "/dev/disk/by-uuid/09b09896-1d5f-4f4e-98e0-120876ece499";

  # Hostname
  networking.hostName = "noxus";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
