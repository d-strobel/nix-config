{pkgs, ...}: {
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
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };

    virtualbox = {
      host = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    dive
    virt-manager
  ];
}
