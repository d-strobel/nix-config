{
  config,
  pkgs,
  ...
}: let
  remminaConfigDir = "${config.home.homeDirectory}/.local/share/remmina";
in {
  services.remmina = {
    enable = true;
    package = with pkgs; remmina;
  };

  sops.secrets = {
    "remmina/connections/rds" = {
      path = "${remminaConfigDir}/sdk_rdp_rds-sdk-local_rds-sdk-local.remmina";
      mode = "0644";
    };
    "remmina/connections/sv0wcon01-p" = {
      path = "${remminaConfigDir}/sdk_rdp_domaincontroller_sv0wcon01-p-sdk-local.remmina";
      mode = "0644";
    };
  };
}
