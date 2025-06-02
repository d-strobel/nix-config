{
  config,
  pkgs,
  ...
}: {
  # SSH keys and config is fully driven by sops-nix
  sops.secrets = {
    # SSH config
    "ssh/config" = {
      path = "${config.home.homeDirectory}/.ssh/config";
      mode = "0600";
    };

    # SSH key-pairs
    "ssh/keys/id_ed25519/private" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      mode = "0600";
    };
    "ssh/keys/id_ed25519/public" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      mode = "0644";
    };
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
