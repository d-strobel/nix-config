{pkgs, ...}: {
  programs.librewolf = {
    enable = true;
    package = with pkgs; librewolf-wayland;

    languagePacks = [
      "en-US"
      "de"
    ];

    policies = {
      Extensions = {
        Locked = [
          # Dark theme
          "firefox-compact-dark@mozilla.org"
          # uBlock Origin
          "uBlock0@raymondhill.net"
          # Bitwarden
          "446900e4-71c2-419f-a6a7-df9c091e268b"
          # Dark reader
          "addon@darkreader.org"
          # SimpleLogin
          "addon@simplelogin"
          # Return YouTube dislike
          "762f9885-5a13-4abd-9c77-433dcd38b8fd"
          # Hide YouTube shorts
          "88ebde3a-4581-4c6b-8019-2a05a9e3e938"
        ];
      };
    };

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
