{pkgs, ...}: {
  programs.keychain = {
    package = with pkgs; keychain;
    enable = true;
    enableFishIntegration = true;
    keys = [
      "id_ed25519"
    ];
  };
}
