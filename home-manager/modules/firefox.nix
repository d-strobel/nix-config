{
  config,
  inputs,
  pkgs,
  ...
}: let
  lockFalse = {
    Value = false;
    Status = "locked";
  };
  lockTrue = {
    Value = true;
    Status = "locked";
  };
in {
  # Import betterfox home-manager module
  imports = [inputs.betterfox.modules.homeManager.betterfox];

  # Firefox configuration
  programs.firefox = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.firefox;

    languagePacks = [
      "en-US"
      "de"
    ];

    # Firefox (polices.json)
    # More information -> about:policies#documentation
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableProfileImport = true;
      DisableMasterPasswordCreation = true;
      PasswordManagerEnabled = false;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://doh.libredns.gr/dns-query";
        Locked = true;
        Fallback = true;
      };
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };

      # Check about:config for options.
      Preferences = {
        "browser.contentblocking.category" = {
          Value = "strict";
          Status = "locked";
        };
        "extensions.pocket.enabled" = lockFalse;
        "extensions.screenshots.disabled" = lockTrue;
        "browser.topsites.contile.enabled" = lockFalse;
        "browser.formfill.enable" = lockFalse;
        "browser.search.suggest.enabled" = lockFalse;
        "browser.search.suggest.enabled.private" = lockFalse;
        "browser.urlbar.suggest.searches" = lockFalse;
        "browser.urlbar.showSearchSuggestionsFirst" = lockFalse;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lockFalse;
        "browser.newtabpage.activity-stream.feeds.snippets" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lockFalse;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lockFalse;
        "browser.newtabpage.activity-stream.showSponsored" = lockFalse;
        "browser.newtabpage.activity-stream.system.showSponsored" = lockFalse;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lockFalse;
        "browser.translations.automaticallyPopup" = lockFalse;
        "browser.uitour.enabled" = lockFalse;
        "browser.uiCustomization.state" = {
          Value = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"_testpilot-containers-browser-action\",\"_88ebde3a-4581-4c6b-8019-2a05a9e3e938_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"customizableui-special-spring1\",\"vertical-spacer\",\"urlbar-container\",\"customizableui-special-spring2\",\"downloads-button\",\"fxa-toolbar-menu-button\",\"unified-extensions-button\",\"addon_darkreader_org-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"addon_simplelogin-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"reset-pbm-toolbar-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"addon_darkreader_org-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"screenshot-button\",\"_testpilot-containers-browser-action\",\"addon_simplelogin-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_88ebde3a-4581-4c6b-8019-2a05a9e3e938_-browser-action\",\"_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action\",\"reset-pbm-toolbar-button\"],\"dirtyAreaCache\":[\"nav-bar\",\"vertical-tabs\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\"],\"currentVersion\":23,\"newElementCount\":2}";
          Status = "locked";
        };
        "network.protocol-handler.external.mailto" = lockFalse;
      };

      # Extensions
      ExtensionSettings = {
        # Block everything but the extensions definded below
        "*".installation_mode = "blocked";

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
          default_area = "navbar";
        };
        # Dark reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "navbar";
        };
        # Firefox Containers
        "@testpilot-containers" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/@testpilot-containers/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{446900e4-71c2-419f-a6a7-df9c091e268b}/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "navbar";
        };
        # Simplelogin
        "addon@simplelogin" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/addon@simplelogin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "navbar";
        };
        # Return YouTube dislike
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{762f9885-5a13-4abd-9c77-433dcd38b8fd}/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Hide YouTube shorts
        "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/{88ebde3a-4581-4c6b-8019-2a05a9e3e938}/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
        # Youtube SponsorBlock
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorBlocker@ajay.app/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = false;
          default_area = "menupanel";
        };
      };
    };

    # Betterfox (user.js) integration
    betterfox = {
      enable = true;
      version = "146.0";

      # Must be equal to firefox profiles module
      profiles.default = {
        enableAllSections = true;

        settings = {
          fastfox = {
            enable = true;
          };
          securefox = {
            enable = true;
          };
        };
      };
    };

    # Define firefox profiles
    profiles.default = {
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
        youtube = {
          id = 2;
          name = "Youtube";
          color = "yellow";
          icon = "circle";
        };
        vault = {
          id = 3;
          name = "Vault";
          color = "red";
          icon = "circle";
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
                name = "Hacker News";
                url = "https://news.ycombinator.com";
              }
              {
                name = "Tuta Mail";
                url = "https://app.tuta.com";
              }
              {
                name = "Github";
                url = "https://github.com";
              }
              {
                name = "Gitlab";
                url = "https://gitlab.com/strobel-iac";
              }
              {
                name = "Codeberg";
                url = "https://codeberg.org";
              }
            ];
          }
        ];
      };
    };
  };
}
