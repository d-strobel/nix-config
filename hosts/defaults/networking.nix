{...}: {
  networking = {
    # Network manager
    networkmanager.enable = true;

    boot.kernel.sysctl = {
      "net.ipv6.conf.all.disable_ipv6" = 1;
    };

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
}
