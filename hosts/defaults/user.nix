{pkgs, ...}: let
  username = "dstrobel";
in {
  # Enable fish for user shell
  programs.fish.enable = true;

  users.users."${username}" = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];

    # Managed by home-manager
    shell = with pkgs; fish;
  };

  # Sudo
  security.sudo.enable = true;
}
