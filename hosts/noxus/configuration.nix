{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  username = "dstrobel";
in {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # LUKS encryption
  boot.initrd.luks.devices."luks-09b09896-1d5f-4f4e-98e0-120876ece499".device = "/dev/disk/by-uuid/09b09896-1d5f-4f4e-98e0-120876ece499";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "noxus";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprlock = {};

  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "${username}";
      };
    };
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # DBus
  services.dbus = {
    enable = true;
    packages = with pkgs; [dconf];
  };

  programs.dconf = {
    enable = true;
  };

  # Enable fish for user shell
  programs.fish.enable = true;

  # User
  users.users."${username}" = {
    initialHashedPassword = "$y$j9T$oBaKT5YqnbXdvecq/tx3X.$GBriGJP22EwEM0MNB5yxt3UDrxX2/t2gHHMNJd8CRuB";
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "wheel"];
    shell = with pkgs; fish;
  };

  # Replace sudo with doas
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = ["wheel"];
        keepEnv = true;
        persist = false;
      }
    ];
  };

  # Additional system packages
  environment.systemPackages = with pkgs; [
    parted
    gparted
    vim
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "de";
      variant = "";
    };
  };

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIFMTCCAxmgAwIBAgIQbcBj3E7Pi5pAbwnfTfbGjjANBgkqhkiG9w0BAQwFADAx
      MQswCQYDVQQGEwJERTEMMAoGA1UEChMDU0RLMRQwEgYDVQQDEwtTREstUk9PVC1D
      QTAeFw0yNDAxMjIxMzU5MDdaFw00MDAxMjkwOTEzMDdaMDExCzAJBgNVBAYTAkRF
      MQwwCgYDVQQKEwNTREsxFDASBgNVBAMTC1NESy1ST09ULUNBMIICIjANBgkqhkiG
      9w0BAQEFAAOCAg8AMIICCgKCAgEApIl5rIgx1mqfmX+w9mjV/Ol53lgox7HJPL/u
      VWldfKWfGirtyfEromq8loOSPc/5fhRo+AJ7Pmn3KTCBS6vAg4g+VpuYhM+hKZRh
      bndixlb/8Gap1BgHJMRtuKxmaW5xGqNXy8yw2HI1h0Jie1LdE93n1yYwmURv9z1G
      IWrkTTYSKc9rhScMM2bWqe6c2UOK+NxDExeyLuUauZeYT9EOuypqIfiCTYC9QTyV
      7vi/M2VvOqwFOFFA37yy6OIFGLYxXC1TtzOR1NEw+PZ89qqXVEIisAgIwU/z1WZ9
      yglByFmFT5+Vlh+DAtMcSHLKNppvdWcsrmh72ueVZOsNklhogZF+QCqRWfy6yDW6
      3vKQoM1Cfh3RLh3L0ZE1igIGgTq0rNJfU4VFjgtCzKGX6K5YPRnH4Dl6Bfwguh3a
      z0JSopRc3mD1bC8PIWJlD0A/5iX34X9EARWrB9/7/oH9qZZ8/f42YYeZucPMu2SI
      y2IeU97ryY2sORTmnLQsUgve3o1DgDWaD0toImcLv4fvJODN8fZi8r2wyDNub7Ht
      9uc7ewlx4W7WFPNDyNg9hZfH1rV2IX9AkOxhNxrBDFtc73lno2nBNDAchsUAgZSk
      gmywv2615WQ3Qp+QOy09bkL9wCEx5wq+wboccrpKa7XiB6Bs68Bwdw4BWP1Arey/
      AoAd9bUCAwEAAaNFMEMwDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8C
      AQEwHQYDVR0OBBYEFKRSg1yGDWYa0ASqRPFcYGVGVApPMA0GCSqGSIb3DQEBDAUA
      A4ICAQAwPzjvtB347N44wLNthKylU45rBuNJzpcgXthiEHMUmGcoIvoshoLtd+Us
      j6jw5bMDTAKZetYXJeH0U6MOAma+Tk+7EFmwWzy6QZOcjo8s02MSj7Uc30uuw9qJ
      tx2Y5Je0GFZVajL+pxGmfiIKpoTsqWxQwoRVZzjGmnO7dGa+BEGDZEnWPlpGC1gU
      P8FTHu8xhRJUQwBinjzmtCSuAT4o0Qm8nfDuuNctOKtqzCJNaH+hL2C23dMo7wft
      EMReYpHiuHkN8jGxm17dVFpvktVOiJ3quLNnkgNyrAviXuJr7ysR/xxkuV5M7J+0
      jJIikg3CvIbHBBFrOmfUOLj331Rep3LnPB6bFhLH51FW1crlVIoeg6qK0eioof2Q
      wW9zdHbAEAPMQiuevl2NIHpMbD/xXqPz2gd3qPHg2pbFI2zX6CFvZ7P9YDaWsTTW
      g6LYGg6guRdLJu5fpjIdgE8ydl94mUmSC7AvniHvbB6P7aeinRL2tgXhjA/vb7ii
      IjbIb9biwZShF++F/g0VROTr60BZE8uPrOX7Aepxf151vMoOCXmkodpKAwBpBjgr
      5tA6ifj7674xAk1SRErSeJtIOppYy5yNT60GIzxtlgLKw1urwnf2SEFw/oPgGer6
      RcruEJbrQVl7mKPNJ1aAFWYLOOeRdW/28ZYKgwF7D/UrepKN6w==
      -----END CERTIFICATE-----
    ''
  ];

  # Configure console keymap
  console.keyMap = "de";
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
