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
      path = "${remminaConfigDir}/sdk_rdp_rds.remmina";
      mode = "0644";
    };
    "remmina/connections/domaincontroller" = {
      path = "${remminaConfigDir}/sdk_rdp_domaincontroller.remmina";
      mode = "0644";
    };
    "remmina/connections/adfs" = {
      path = "${remminaConfigDir}/sdk_rdp_adfs.remmina";
      mode = "0644";
    };
  };
}
