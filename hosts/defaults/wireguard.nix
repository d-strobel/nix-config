{
  # Enable Wireguard
  networking.wireguard.enable = true;

  # Setup interfaces from sops secrets
  sops.secrets = {
    "wireguard/wg1" = {};
  };

  # networking.wg-quick.interfaces = {
  #   wg0.configFile = "wireguard/wg0";
  # };
}
