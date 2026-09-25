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
        allow id 1d6b:0002 serial "0000:00:14.0" name "xHCI Host Controller" hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
        allow id 1d6b:0003 serial "0000:00:14.0" name "xHCI Host Controller" hash "XCHNkqbiDxI/M86q3Xx/1NPsFNctpAcKPF2KF9AkPpY=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
        allow id 1d6b:0002 serial "0000:3c:00.0" name "xHCI Host Controller" hash "+k9gUUE6Cnbob2WB/I//KMZ1hZ1UgvI6RrqNkIDvdmQ=" parent-hash "zCxLdr73Tn0YoKg15XR1ttIXizl8vMD+KtVAQnBZO8I=" with-interface 09:00:00 with-connect-type ""
        allow id 1d6b:0003 serial "0000:3c:00.0" name "xHCI Host Controller" hash "KkQZN5DqcZCTZozZRGI/Qr09HJrHE8L5Ml5YlUl2G3Y=" parent-hash "zCxLdr73Tn0YoKg15XR1ttIXizl8vMD+KtVAQnBZO8I=" with-interface 09:00:00 with-connect-type ""
        allow id 2109:2817 serial "" name "USB2.0 Hub             " hash "I0EyQg3EPh4pnLnd0hJMXwPi69STx6hDl43+nji0FxA=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-1" with-interface { 09:00:01 09:00:02 } with-connect-type "hotplug"
        allow id 058f:9540 serial "" name "EMV Smartcard Reader" hash "j6z/wqFtA1bZWwBIPmIr/g8KfsEQJ63vpgf4cBcNLbU=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-3" with-interface 0b:00:00 with-connect-type "not used"
        allow id 8087:0a2b serial "" name "" hash "TtRMrWxJil9GOY/JzidUEOz0yUiwwzbLm8D7DJvGxdg=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-7" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "not used"
        allow id 04f2:b604 serial "0001" name "Integrated Camera" hash "Sra5Do2lULxlGqcVOc0E68CJLWT1st8KiYXu4dbUQoQ=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { 0e:01:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 } with-connect-type "not used"
        allow id 06cb:009a serial "176bb407c4ef" name "" hash "vA8TYlGOgvX8lO6gCOGyqpKROqeqveEaV5lInGaxn7Q=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface ff:00:00 with-connect-type "not used"
        allow id 2109:0817 serial "" name "USB3.0 Hub             " hash "vQNT567XT+bPBqIu0p/etX+pnHWglTlGAjGJuRFxsxA=" parent-hash "XCHNkqbiDxI/M86q3Xx/1NPsFNctpAcKPF2KF9AkPpY=" via-port "2-1" with-interface 09:00:00 with-connect-type "hotplug"
        allow id 0bda:0316 serial "20120501030900000" name "USB3.0-CRW" hash "WG1MSC3YZsmCslTNGpjTTjT2lUvhNfU4gEVvD3gIuV4=" parent-hash "XCHNkqbiDxI/M86q3Xx/1NPsFNctpAcKPF2KF9AkPpY=" with-interface 08:06:50 with-connect-type "not used"
        allow id 05ac:0250 serial "" name "Keychron K2" hash "Ve+iuk3i2DIWlQQWnbTUbGbwFPk913tgx8Qpip54foA=" parent-hash "I0EyQg3EPh4pnLnd0hJMXwPi69STx6hDl43+nji0FxA=" via-port "1-1.2" with-interface { 03:01:01 03:01:02 } with-connect-type "unknown"
        allow id 1050:0407 serial "" name "YubiKey OTP+FIDO+CCID" hash "Q+A8QQReKclmBSaDIYja0w4Bx6ld2IU6wF7HFKdtJ3Q=" parent-hash "I0EyQg3EPh4pnLnd0hJMXwPi69STx6hDl43+nji0FxA=" via-port "1-1.3" with-interface { 03:01:01 03:00:00 0b:00:00 } with-connect-type "unknown"
        allow id 04a5:8001 serial "" name "BenQ ZOWIE Gaming Mouse" hash "Rfmn4vEZ5Jh/iqGZ739u7SpoJP3tx8iAponKBSJoKhU=" parent-hash "I0EyQg3EPh4pnLnd0hJMXwPi69STx6hDl43+nji0FxA=" via-port "1-1.4" with-interface 03:01:02 with-connect-type "unknown"
      '';
      IPCAllowedGroups = [];
      IPCAllowedUsers = ["root"];
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
