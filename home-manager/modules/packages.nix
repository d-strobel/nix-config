{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    vlc
    winbox
    brave

    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # CLI tools
    btop
    ripgrep
    fd
    wavemon
    openssl

    # Kubernetes tools
    k9s
    kind
    kubectl
    kubectx
    talosctl
    kubelogin
    kubelogin-oidc
  ];
}
