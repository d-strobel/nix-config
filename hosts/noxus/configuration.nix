{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../defaults
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-1b73dd99-61d5-4de1-a5c1-16f5377f8f1a".device = "/dev/disk/by-uuid/1b73dd99-61d5-4de1-a5c1-16f5377f8f1a";
  networking = {
    hostName = "noxus";
    extraHosts = ''
      192.168.11.10 vaultwarden.dstrobel.com
      192.168.178.240 vault.dstrobel.com
    '';
  };

  # Firewall
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
