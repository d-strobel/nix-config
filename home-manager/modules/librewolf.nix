{
  config,
  pkgs,
  ...
}: {
  programs.librewolf = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.librewolf;

    languagePacks = [
      "en-US"
      "de"
    ];

    # Enable WebGL, cookies and history
    settings = {
      "webgl.disabled" = false;
      # "privacy.resistFingerprinting" = true;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
    };

    policies = {
      ExtensionSettings = {
        # "*".installation_mode = "blocked";

        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    # Extensions = {
    #   Locked = [
    #     # uBlock Origin
    #     "uBlock0@raymondhill.net"
    #     # Bitwarden
    #     "446900e4-71c2-419f-a6a7-df9c091e268b"
    #     # Dark reader
    #     "addon@darkreader.org"
    #     # SimpleLogin
    #     "addon@simplelogin"
    #     # Return YouTube dislike
    #     "762f9885-5a13-4abd-9c77-433dcd38b8fd"
    #     # Hide YouTube shorts
    #     "88ebde3a-4581-4c6b-8019-2a05a9e3e938"
    #   ];
    # };

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
          default = "ddg";
          privateDefault = "ddg";
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

            bing.metaData.hidden = true;
            google.metaData.hidden = true;
          };
        };

        bookmarks = {
          force = true;
          settings = [
            {
              name = "Toolbar";
              toolbar = true;
              bookmarks = [
                # Define Toolbar bookmarks here
                {
                  name = "Tuta Mail";
                  url = "https://app.tuta.com/login";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
