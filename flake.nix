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
  in {
    # NixOS configuration entrypoint
    # Available through 'sudo nixos-rebuild switch --flake .#noxus'
    nixosConfigurations = {
      noxus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/noxus/configuration.nix
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
          mage-fish-completions = inputs.mage-fish-completions;
          lasergraph-timecode-importer = inputs.lasergraph-timecode-importer;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
