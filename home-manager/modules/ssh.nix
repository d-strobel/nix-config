{
  config,
  pkgs,
  ...
}: {
  # SSH keys and config is fully driven by sops-nix
  sops.secrets = {
    "ssh/keys/id_ed25519_vault-prod/private" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_vault-prod";
      mode = "0600";
    };
    "ssh/keys/id_ed25519_vault-prod/public" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519_vault-prod.pub";
      mode = "0644";
    };
  };

  # Keychain is used to input the ssh key password once after startup
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
