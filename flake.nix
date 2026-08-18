{
  description = "Nix configurations for Diamond and Bort";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    nixcord.url = "github:4evy/nixcord";
    matugen.url = "github:/InioX/Matugen";

    vicinae = {
      url = "github:vicinaehq/vicinae/11f58c008d62fa10fe364a6010f5b5f8f8200a56";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";

    helium = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    darwin,
    ...
  }: let
    inherit (nixpkgs) lib;
    hosts = import ./config/host.nix;
    theme = import ./lib/theme.nix {inherit lib;};
    colorMix = import ./lib/color-mix.nix;

    mkSpecialArgs = host:
      inputs
      // host
      // {
        inherit theme colorMix;
      };

    diamond = hosts.Diamond;
    bort = hosts.Bort;
  in {
    darwinConfigurations.Diamond = darwin.lib.darwinSystem {
      inherit (diamond) system;
      specialArgs = mkSpecialArgs diamond;
      modules = [
        ./hosts/Diamond
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "backup";
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = mkSpecialArgs diamond;
          home-manager.users.${diamond.username} = import ./home;
        }
      ];
    };

    nixosConfigurations.Bort = nixpkgs.lib.nixosSystem {
      inherit (bort) system;
      specialArgs = mkSpecialArgs bort;
      modules = [
        ./hosts/Bort
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "backup";
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = mkSpecialArgs bort;
          home-manager.users.${bort.username} = import ./home;
        }
      ];
    };

    formatter = lib.genAttrs [diamond.system bort.system] (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
