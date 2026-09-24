{
  description = "Personal NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Sops-nix secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets from private repo
    nix-secrets = {
      url = "git+https://github.com/d-strobel/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };

    # Jay wayland compositor
    jay = {
      url = "github:mahkoh/jay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Neovim nightly overlay
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helium browser
    helium-browser.url = "github:schembriaiden/helium-browser-nix-flake";

    # Betterfox
    betterfox.url = "github:HeitorAugustoLN/betterfox-nix";

    # Mage fish completions
    mage-fish-completions.url = "github:d-strobel/mage-fish-completions";

    # Laser-tools
    lasergraph-timecode-importer.url = "github:laser-zentrale-de/lasergraph-timecode-importer";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS system configuration
    nixosConfigurations = {
      # Use with: sudo nixos-rebuild switch --flake .#noxus
      noxus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/noxus/configuration.nix
        ];
      };
      # Use with: sudo nixos-rebuild switch --flake .#piltover
      piltover = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/piltover/configuration.nix
        ];
      };
    };

    # Standalone home-manager configuration
    homeConfigurations = {
      # Use with: home-manager switch --flake .#dstrobel
      "dstrobel" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
