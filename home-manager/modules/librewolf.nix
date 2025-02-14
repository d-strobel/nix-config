{pkgs, ...}: {
  programs.librewolf = {
    enable = true;
    package = with pkgs; librewolf-wayland;

    languagePacks = [
      "en-US"
      "de"
    ];

    profiles = {
      default = {
        id = 0;
        name = "Default";

        containersForce = true;
        containers = {
          laser = {
            id = 1;
            name = "Laser";
            color = "green";
            icon = "circle";
          };
          google = {
            id = 2;
            name = "Google";
            color = "yellow";
            icon = "chill";
          };
        };

        search = {
          default = "DuckDuckGo";
          privateDefault = "DuckDuckGo";
          force = true;

          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/index.php?search={searchTerms}";}];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nw"];
            };

            "Bing".metaData.hidden = true;
            "Google".metaData.hidden = true;
          };
        };
      };
    };
  };
}
