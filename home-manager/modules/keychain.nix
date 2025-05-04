{pkgs, ...}: {
  programs.keychain = {
    package = with pkgs; keychain;
    enable = true;
    enableFishIntegration = true;
    keys = [
      "id_ed25519"
      "id_ed25519_vault-prod"
    ];
  };
}
