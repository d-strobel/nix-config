{
  dconf.settings = {
    # GTK settings
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    # Libvirt config
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
