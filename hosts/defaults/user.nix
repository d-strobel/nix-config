{pkgs, ...}: let
  username = "dstrobel";
in {
  # Enable fish for user shell
  programs.fish.enable = true;

  users.users."${username}" = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = ["networkmanager" "wheel"];

    # Managed by home-manager
    shell = with pkgs; fish;
  };

  # Replace sudo with doas
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = ["${username}"];
        keepEnv = true;
        persist = false;
      }
    ];
  };
}
