{pkgs, ...}: let
  username = "dstrobel";
in {
  # Enable fish for user shell
  programs.fish.enable = true;

  users.users."${username}" = {
    initialHashedPassword = "$y$j9T$oBaKT5YqnbXdvecq/tx3X.$GBriGJP22EwEM0MNB5yxt3UDrxX2/t2gHHMNJd8CRuB";
    isNormalUser = true;
    description = "Main user";
    extraGroups = ["networkmanager" "wheel"];

    # Managed by home-manager
    shell = with pkgs; fish;
  };

  # Replace sudo with doas
  security.sudo.enable = true;
  security.doas = {
    enable = false;
    extraRules = [
      {
        groups = ["wheel"];
        keepEnv = true;
        persist = false;
      }
    ];
  };
}
