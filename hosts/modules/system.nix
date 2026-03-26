{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  secretsPath = toString inputs.nix-secrets;
  username = "dstrobel";
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # --------------------
  # Nix configuration
  # --------------------
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = ["nix-command" "flakes" "recursive-nix" "ca-derivations"];
      flake-registry = ""; # Opinionated: disable global registry
      nix-path = config.nix.nixPath; # Workaround for https://github.com/NixOS/nix/issues/9574
      auto-optimise-store = true;
      builders-use-substitutes = true;
      max-jobs = "auto";
      keep-going = true;
      warn-dirty = false;
      http-connections = 0;
      accept-flake-config = true;
      keep-derivations = true;
      keep-outputs = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
  nixpkgs = {
    config.allowUnfree = true;
  };

  # --------------------
  # User
  # --------------------
  users.users."${username}" = {
    uid = 1000;
    isNormalUser = true;
    description = "Main user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    shell = with pkgs; fish;
  };

  # --------------------
  # Packages
  # --------------------
  environment.systemPackages = with pkgs; [
    # Basic CLI tools
    git
    vim
    wget
    zip
    unzip
    btop
    dig
    parted

    # Wayland utils
    wayland-utils
    lxqt.lxqt-policykit

    # VM-Management
    dive
    virt-manager

    # Networking
    networkmanagerapplet

    # Misc
    hardinfo2
    engrampa
  ];

  # Shells
  programs.bash.enable = true;
  programs.fish.enable = true;

  # Helium Browser
  programs.chromium = {
    enable = true;
    extraOpts = {
      "SpellcheckEnabled" = false;
    };
  };

  # --------------------
  # Window-Manager
  # --------------------

  # Login manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
      };
    };
  };

  # xdg-desktop-portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # Wayland Compositor
  programs.sway = {
    enable = true;
    xwayland.enable = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      swaybg
      sway-contrib.grimshot
    ];

    # These options gives us some usefull files to include
    # in our sway config (/etc/sway/config.d/*)
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
  };

  # Native wayland support in all chrome and most electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Swaylock unlocking
  security.pam.services.swaylock = {};

  # Keyrings
  services.gnome.gnome-keyring.enable = true;

  # Automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # DBus
  services.dbus = {
    enable = true;
    packages = with pkgs; [dconf];
  };
  programs.dconf.enable = true;

  # File manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # --------------------
  # Virtualisation
  # --------------------
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      package = with pkgs; podman;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = with pkgs; qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
  };

  # --------------------
  # Systemd services
  # --------------------
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi'';
    };
  };

  # --------------------
  # Settings
  # --------------------

  # Timezone
  time.timeZone = "Europe/Berlin";

  # Default language english
  i18n.defaultLocale = "en_US.UTF-8";

  # Locale stuff german
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

  # Keyboard
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  # --------------------
  # Hardware
  # --------------------

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
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      startWhenNeeded = true;
    };
  };

  # Enable thunderbolt ports
  services.hardware.bolt.enable = true;

  # Enable laptop lid closing functions:
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  # --------------------
  # Network
  # --------------------
  networking = {
    # Network manager
    networkmanager = {
      enable = true;
      package = with pkgs; networkmanager;
      plugins = [
        pkgs.networkmanager-openvpn
        pkgs.networkmanager-fortisslvpn
      ];

      dispatcherScripts = [
        {
          # Captive-Portal script
          source =
            pkgs.writeText "captivePortal"
            /*
            bash
            */
            ''
              logger="logger -s -t captive-portal"

              open_captive() {
              	captive_url=http://$(ip --oneline route get 1.1.1.1 | awk '{print $3}')
              	sudo -u "$1" DISPLAY=":0" \
              		DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$(id -u "$1")"/bus \
              		xdg-open "$captive_url"
              }

              case "$2" in
              	connectivity-change)
              		$logger "dispatcher script triggered on connectivity change: $CONNECTIVITY_STATE"

              		if [ "$CONNECTIVITY_STATE" = "PORTAL" ]; then
              			user=$(who | head -n1 | cut -d' ' -f 1)

              			$logger "Running browser as '$user' to login in captive portal"

              			open_captive "$user" || $logger "Failed for user: '$user'"
              		fi
              		;;
              	*) exit 0 ;;
              esac
            '';
          type = "basic";
        }
      ];
    };

    # Enable Wireguard
    wireguard.enable = true;

    # Edit hosts file
    extraHosts = ''
      192.168.11.10 vaultwarden.dstrobel.com
      192.168.178.240 vault.dstrobel.com
    '';

    # Firewall settings
    firewall = {
      enable = true;
      allowedTCPPorts = [
        53317 # localsend
      ];
    };
  };

  # --------------------
  # Certificates
  # --------------------
  security.pki.certificates = [
    # SDK-Root
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
    # SDK-SUB
    ''
      -----BEGIN CERTIFICATE-----
      MIIGQjCCBCqgAwIBAgITZwAAAAaP6ewnBDIRJQABAAAABjANBgkqhkiG9w0BAQsF
      ADAxMQswCQYDVQQGEwJERTEMMAoGA1UEChMDU0RLMRQwEgYDVQQDEwtTREstUk9P
      VC1DQTAeFw0xODA5MTExMTQxMDZaFw0yNjA5MTExMTUxMDZaMEExFTATBgoJkiaJ
      k/IsZAEZFgVsb2NhbDETMBEGCgmSJomT8ixkARkWA1NESzETMBEGA1UEAxMKU0RL
      LVNVQi1DQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALIdkp+sZnEB
      sbfctGDZnBFVRMYOSstiQjYqTjSVKGFNBjfcsfhEPek4eADc/MG6Av3eHQ0uS2/U
      GAsFMdUvl96ehZPW9W3KSVdETTHkP3tUdw2K42MklLgm1uFx+lPdA6pcFZj/k5Js
      l4ulW8mMbR6cQw0lk302iRTmk26e0Bt8CY1pnHHrOAI11J5P0BZBXc5Jx1qU0Q72
      06QjHDvPzss/RD9JpGVKu5M3VvuKTekrz8D8WKefGWIuj6g/QN6NZIxb0VXfZd/n
      c1zIwHJUiAMsPWZoZTpOaYrdh2U7pRfymUmrMf6ubJ2wpwpsN/wkRU8jnRjN3uoV
      YKzy7l9o0TECAwEAAaOCAkEwggI9MBAGCSsGAQQBgjcVAQQDAgEBMCMGCSsGAQQB
      gjcVAgQWBBR3WdZvORGQvU94mdSw8sl1QGJCcTAdBgNVHQ4EFgQUkWg+gR8N5rVT
      50N7veRxJ7GVx+8wGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQD
      AgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUNiU6An3tC5oZSaVo0d+P
      x3AQY3swgcwGA1UdHwSBxDCBwTCBvqCBu6CBuIaBtWxkYXA6Ly8vQ049U0RLLVJP
      T1QtQ0EoMSksQ049cy1yb290LWNhLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBT
      ZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXNkayxEQz1s
      b2NhbD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9
      Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgbsGCCsGAQUFBwEBBIGuMIGrMIGoBggrBgEF
      BQcwAoaBm2xkYXA6Ly8vQ049U0RLLVJPT1QtQ0EsQ049QUlBLENOPVB1YmxpYyUy
      MEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9
      c2RrLERDPWxvY2FsP2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0
      aWZpY2F0aW9uQXV0aG9yaXR5MA0GCSqGSIb3DQEBCwUAA4ICAQBOYlw+PDl4tMQu
      aX5igzv/OVOxPw3uR3ixBn9sO3pQHQYGHePktjMNjBs9qFlJMJW7TmI7E4t/k1Bx
      bJdDK8HKIz5RvDG9EAs5CDjSNNZbegnI68ZuYU2Ft3upA0NF131cHaNrQnJQ8L7C
      FHCIH9ffpAtmfuPX29YXgjaCwSg1/fk/lMFsR7otN8hrE033sXhfc5JvWUuFKx1b
      E1yPDx6Cy2j+K/frwZT7TG/lsAMUhXvnSJlLXx7VrlfB5tCp7lREvfY9egpiS0OW
      xuhaadMseaMB2SnDdK9BWiMd3GsMK3vIeUyFiv45KyX9SNlvWxsAcggY3X6cRLYo
      cC+LmZJsPCRBm9zCtTVHqgWqvX+iXVVGqUdxUwQKGmfETRRwHMUCJ9E7WN2Plqbc
      5TY9ayk0SwjIfMJyybbeySZ4taI1MWBEh3zzT0+TX6Lqj/jNzulxlJR5rN/uOXD4
      m644hFq/X+VP2D80d1+ypSdrv/vqDSdiloTJiKuRPF3+HN9cn9F7S6z/E91W4py9
      JVVxEYGnAOSqxFMb5k21g2FHe/q2z2VnV08/4/ktzEqAtU7Q4m0tn8T5mFtCILTH
      j6am+2Go4FvOf3io5qB1nj5sIGRIBMcq6bidLJIgE+3TVzxDnJZoiTWlhPsaH7xB
      6Km044puutyJ2UhSc8JPa7DAE3A/bw==
      -----END CERTIFICATE-----
    ''
  ];

  # --------------------
  # Security
  # --------------------

  # copied and saved for later use
  # services = {
  #   usbguard = {
  #     enable = true;
  #     rules = ''
  #       allow id 1d6b:0002 serial "0000:00:14.0" name "xHCI Host Controller" hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
  #       allow id 1d6b:0003 serial "0000:00:14.0" name "xHCI Host Controller" hash "3Wo3XWDgen1hD5xM3PSNl3P98kLp1RUTgGQ5HSxtf8k=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
  #       allow id 1235:8211 serial "Y72EB6E1AD7499" name "Scarlett Solo USB" hash "vYKb5BFrLgfYzbTqAtyq0N2yZisUuqjchfbd1NjGgiE=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { 01:01:20 01:02:20 01:02:20 01:02:20 01:02:20 ff:01:20 } with-connect-type "hotplug"
  #       allow id 258a:0033 serial "" name "Wired Gaming Mouse" hash "NjvNTGeMdzH8KOqM6YIuBwfVCZluftC/mdg5mR2aLlY=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-2" with-interface { 03:01:02 03:01:01 } with-connect-type "hotplug"
  #       allow id 046d:c539 serial "" name "USB Receiver" hash "zPVf0/h8u0iaLZgla3hm9BjINDTSEEIMF/GWCyOYCwo=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-3" with-interface { 03:01:01 03:01:02 03:00:00 } with-connect-type "hotplug"
  #       allow id 1050:0407 serial "" name "YubiKey OTP+FIDO+CCID" hash "Q+A8QQReKclmBSaDIYja0w4Bx6ld2IU6wF7HFKdtJ3Q=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-5" with-interface { 03:01:01 03:00:00 0b:00:00 } with-connect-type "hotplug"
  #       allow id 04f2:b50c serial "" name "HP Truevision HD" hash "xR2ZRjJzpB6sW1I9lU5CPcYRjCiW23iyfnr67QjSNWw=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-6" with-interface { 0e:01:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 0e:02:00 } with-connect-type "hardwired"
  #       allow id 8087:0a2a serial "" name "" hash "7jCRH2DCYUfdP9zZCYIQH6Z5QWx8Nzt8sX21UHwxIqA=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-7" with-interface { e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 e0:01:01 } with-connect-type "hardwired"
  #       allow id 04f3:22f6 serial "" name "Touchscreen" hash "x1+RDZDWJlnHus7DN6iDdnCOJj52ogmObdk0JlocWtc=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-8" with-interface 03:00:00 with-connect-type "hardwired"
  #     '';
  #     #dbus.enable = true;
  #     IPCAllowedGroups = ["wheel"];
  #     IPCAllowedUsers = [];
  #   };
  # };

  security = {
    # Enable sudo-rs
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      package = with pkgs; sudo-rs;
      execWheelOnly = true;
    };

    polkit.enable = true;
    protectKernelImage = true;
    lockKernelModules = false; # breaks virtd, wireguard and iptables

    # force-enable the Page Table Isolation (PTI) Linux kernel feature
    forcePageTableIsolation = true;

    # User namespaces are required for sandboxing. Better than nothing imo.
    allowUserNamespaces = true;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = with pkgs; [apparmor-profiles];
    };

    virtualisation = {
      # flush the L1 data cache before entering guests
      flushL1DataCache = "always";
    };
  };

  # Security tweaks borrowed from @hlissner & @fufexan & @NotAShelf.
  # And I borrowed it from @yavko :)
  boot.kernel.sysctl = {
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;

    # TCP hardening

    # Prevent bogus ICMP errors from filling up logs.
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Reverse path filtering causes the kernel to do source validation of
    # packets received from all interfaces. This can mitigate IP spoofing.
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;

    # Do not accept IP source route packets (we're not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;

    # Don't send ICMP redirects (again, we're on a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # Refuse ICMP redirects (MITM mitigations)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Protects against SYN flood attacks
    "net.ipv4.tcp_syncookies" = 1;

    # Incomplete protection again TIME-WAIT assassination
    "net.ipv4.tcp_rfc1337" = 1;

    # TCP optimization

    # TCP Fast Open is a TCP extension that reduces network latency by packing
    # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
    # both incoming and outgoing connections:
    "net.ipv4.tcp_fastopen" = 3;

    # Bufferbloat mitigations + slight improvement in throughput & latency
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";

    "kernel.kexec_load_disabled" = 1;

    # Restrict ptrace() usage to processes with a pre-defined relationship
    # (e.g., parent/child)
    "kernel.yama.ptrace_scope" = 2;

    # Hide kptrs even for processes with CAP_SYSLOG
    "kernel.kptr_restrict" = 2;

    # Disable bpf() JIT (to eliminate spray attacks)
    "net.core.bpf_jit_enable" = false;

    # Disable ftrace debugging
    "kernel.ftrace_enabled" = false;
  };
  boot.kernelModules = ["tcp_bbr"];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "vivid"
    "gfs2"
    "ksmbd"
    "cramfs"
    "freevxfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "squashfs"
    "udf"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
  ];

  # --------------------
  # SOPS secrets
  # --------------------
  sops = {
    age.keyFile = "/var/lib/sops/age/keys.txt";
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = true;

    secrets = {
      # Wifi connections
      "networkmanager/connections/wifi-wpower" = {
        path = "/etc/NetworkManager/system-connections/wifi-wpower.nmconnection";
        mode = "0600";
      };
      "networkmanager/connections/wifi-translivematter" = {
        path = "/etc/NetworkManager/system-connections/wifi-translivematter.nmconnection";
        mode = "0600";
      };
      "networkmanager/connections/wifi-luke_skyrouter" = {
        path = "/etc/NetworkManager/system-connections/wifi-luke_skyrouter.nmconnection";
        mode = "0600";
      };
      "networkmanager/connections/wifi-iphone_ds" = {
        path = "/etc/NetworkManager/system-connections/wifi-iphone_ds.nmconnection";
        mode = "0600";
      };

      # VPN connections
      "networkmanager/connections/vpn-sdk" = {
        path = "/etc/NetworkManager/system-connections/vpn-sdk.nmconnection";
        mode = "0600";
      };

      # Wireguard connections
      "networkmanager/connections/wg-buchhaldenstrasse" = {
        path = "/etc/NetworkManager/system-connections/wg-buchhaldenstrasse.nmconnection";
        mode = "0600";
      };
      "networkmanager/connections/wg-pommerstrasse" = {
        path = "/etc/NetworkManager/system-connections/wg-pommerstrasse.nmconnection";
        mode = "0600";
      };
    };
  };
}
