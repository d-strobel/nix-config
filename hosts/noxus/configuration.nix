{pkgs, ...}: {
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

  # Video acceleration
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {
      enableHybridCodec = true;
    };
  };
  hardware.graphics = {
    # hardware.graphics since NixOS 24.11
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  # Laptop closing the lid:
  # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend", "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchExternalPower = "suspend";
  # Do nothing when other monitors are plugged in.
  services.logind.lidSwitchDocked = "ignore";

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
