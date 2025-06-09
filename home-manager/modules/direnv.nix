{
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;
    package = with pkgs; direnv;

    nix-direnv = {
      enable = true;
      package = with pkgs; nix-direnv;
    };
  };

  # Deploy envrc
  sops.secrets = let
    home = config.home.homeDirectory;
  in {
    "direnv/git/gitlab.com/strobel-iac/envrc" = {
      path = "${home}/git/gitlab.com/strobel-iac/.envrc";
      mode = "0600";
    };
    "direnv/git/github.com/envrc" = {
      path = "${home}/git/github.com/.envrc";
      mode = "0600";
    };
  };
}
