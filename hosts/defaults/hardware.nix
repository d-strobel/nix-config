{
  # Enable networkmanager
  networking = {
    networkmanager.enable = true;
    wireguard.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  # Enable audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable printing
  services = {
    printing = {
      enable = true;
      startWhenNeeded = true;
    };
  };
}
