{
  description = "Personal NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Mage fish completions
    mage-fish-completions.url = "github:d-strobel/mage-fish-completions";

    # Laser-tools
    lasergraph-timecode-importer.url = "github:laser-zentrale-de/lasergraph-timecode-importer";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    defaultCfg = rec {
      username = "dstrobel";
      homeDirectory = "/home/${username}";
      runtimeRoot = "${homeDirectory}/git/github.com/d-strobel/nix-config";
      context = self;
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'sudo nixos-rebuild switch --flake .#noxus'
    nixosConfigurations = {
      noxus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          nix-secrets = inputs.nix-secrets;
        };
        modules = [
          ./hosts/noxus/configuration.nix
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager switch --flake .#dstrobel'
    homeConfigurations = {
      "dstrobel" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          cfg = defaultCfg;
          mage-fish-completions = inputs.mage-fish-completions;
          lasergraph-timecode-importer = inputs.lasergraph-timecode-importer;
          nix-secrets = inputs.nix-secrets;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };

    # Dev shell
    devShells = {
      x86_64-linux = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      in {
        default = with pkgs;
          mkShell {
            buildInputs = [
              pre-commit
              nodejs
              nodePackages.npm
              age
              sops
            ];

            shellHook = ''
              HOOK_PATH=$(git rev-parse --git-path hooks/pre-commit)
              if [ ! -f "$HOOK_PATH" ]; then
                echo "Setting up pre-commit hooks..."
                ${pkgs.pre-commit}/bin/pre-commit install
              fi
            '';
          };
      };
    };
  };
}
