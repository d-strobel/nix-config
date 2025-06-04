{
  config,
  pkgs,
  ...
}: let
  fishFunctionDir = "${config.home.homeDirectory}/.config/fish/functions";
in {
  home.packages = with pkgs; [
    freerdp3
  ];

  sops.secrets = {
    "freerdp/functions/rds" = {
      path = "${fishFunctionDir}/rdp-rds.fish";
      mode = "0740";
    };
    "freerdp/functions/sv0wcon01-p" = {
      path = "${fishFunctionDir}/rdp-sv0wcon01-p.fish";
      mode = "0740";
    };
    "freerdp/functions/sv0wcon02-p" = {
      path = "${fishFunctionDir}/rdp-sv0wcon02-p.fish";
      mode = "0740";
    };
  };
}
