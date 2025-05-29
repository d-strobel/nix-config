{
  inputs,
  nix-secrets,
  ...
}: let
  secretsPath = builtins.toString nix-secrets;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.keyFile = "/var/lib/sops/age/keys.txt";
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = true;
  };
}
