{pkgs, ...}: let
  username = "dstrobel";
in {
  # Enable fish for user shell
  programs.fish.enable = true;

  users.users."${username}" = {
    uid = 1000;
    isNormalUser = true;
    description = "Main user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "vboxusers"
    ];

    # Managed by home-manager
    shell = with pkgs; fish;
  };

  # Sudo
  security.sudo.enable = true;
}
