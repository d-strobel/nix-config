{
  config,
  inputs,
  nix-secrets,
  ...
}: let
  secretsPath = builtins.toString nix-secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = true;

    # Deploy secrets that are not corresponding to a seperate module
    secrets = {
      "netrc" = {
        path = "${config.home.homeDirectory}/.netrc";
        mode = "0600";
      };
    };
  };
}
