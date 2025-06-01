{
  # Enable Wireguard
  networking.wireguard.enable = true;

  # Setup interfaces from sops secrets
  sops.secrets = {
    "wireguard/wg0" = {};
    "wireguard/wg1" = {};
  };

  networking.wg-quick.interfaces = let
    # Do not start wireguard tunnels automatically
    autostart = false;
  in {
    wg0 = {
      configFile = "/run/secrets/wireguard/wg0";
      autostart = autostart;
    };
    wg1 = {
      configFile = "/run/secrets/wireguard/wg1";
      autostart = autostart;
    };
  };
}
