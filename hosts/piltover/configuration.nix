# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../system.nix
    ];

  services = {
    usbguard = {
      enable = true;
      # To get blocked devices: usbguard list-devices -b
      rules = ''
        allow id 05ac:0250 name "Keychron K2" hash "Ve+iuk3i2DIWlQQWnbTUbGbwFPk913tgx8Qpip54foA="
        allow id 1050:0407 name "YubiKey OTP+FIDO+CCID" hash "Q+A8QQReKclmBSaDIYja0w4Bx6ld2IU6wF7HFKdtJ3Q="
        allow id 04a5:8001 name "BenQ ZOWIE Gaming Mouse" hash "Rfmn4vEZ5Jh/iqGZ739u7SpoJP3tx8iAponKBSJoKhU="
        allow id 04f2:b604 serial "0001" name "Integrated Camera" hash "Sra5Do2lULxlGqcVOc0E68CJLWT1st8KiYXu4dbUQoQ="
        allow id 06cb:009a serial "176bb407c4ef" hash "vA8TYlGOgvX8lO6gCOGyqpKROqeqveEaV5lInGaxn7Q="
        allow id 058f:9540 name "EMV Smartcard Reader" hash "j6z/wqFtA1bZWwBIPmIr/g8KfsEQJ63vpgf4cBcNLbU="
        allow id 058f:6387 serial "CDEE572F" name "Mass Storage" hash "fT4h6Vron885t4b7D4AQsaF8Y+w1dogoUkc9LFr6K0k="
        allow id 0bda:0316 serial "20120501030900000" name "USB3.0-CRW" hash "WG1MSC3YZsmCslTNGpjTTjT2lUvhNfU4gEVvD3gIuV4="
        allow id 8087:0a2b hash "TtRMrWxJil9GOY/JzidUEOz0yUiwwzbLm8D7DJvGxdg="
        allow id 0781:5595 serial "4C530000090503101133" name "Ultra USB 3.0" hash "hbUuAy9v368Q9NjlUKt5gKTZLJMJz7Loe8ZhGN7s4V4="
        allow id 05dc:a838 serial "AAQZC6C87ZM46YD7" name "USB Flash Drive" hash "yfdwVxGmYIUDtPbRaK9APa2QWGfxh50xyUF4AzIKzXs="
        allow id 2109:2817 name "USB2.0 Hub" hash "I0EyQg3EPh4pnLnd0hJMXwPi69STx6hDl43+nji0FxA="
        allow id 2109:0817 name "USB3.0 Hub" hash "vQNT567XT+bPBqIu0p/etX+pnHWglTlGAjGJuRFxsxA="
        # allow id abcd:1234 hash "WwLIxRVjks6yVS9HHhP1Vn3rryx6WklV8RXeIlNoXag="
      '';
      IPCAllowedGroups = ["wheel"];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-d5338498-96cf-45ed-9b33-d29661e39acf".device = "/dev/disk/by-uuid/d5338498-96cf-45ed-9b33-d29661e39acf";
  networking.hostName = "piltover"; # Define your hostname.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
