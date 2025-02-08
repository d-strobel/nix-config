{pkgs}: {
  users.users.dstrobel = {
    initialHashedPassword = "$y$j9T$oBaKT5YqnbXdvecq/tx3X.$GBriGJP22EwEM0MNB5yxt3UDrxX2/t2gHHMNJd8CRuB";
    isNormalUser = true;
    description = "dstrobel";
    extraGroups = ["networkmanager" "wheel"];

    # Managed by home-manager
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
}
