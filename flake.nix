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

    tether = {
      url = "github:zackb/tether";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae/11f58c008d62fa10fe364a6010f5b5f8f8200a56";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    paneru = {
      url = "github:enocla/paneru/9fff52c238b7a1f6f6a7149ff554f462c8e8b33f";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-v2 = {
      url = "github:anomalyco/opencode/v2";
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

    mkHomeManager = host: {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      useUserPackages = true;
      extraSpecialArgs = mkSpecialArgs host;
      users.${host.username} = import ./home;
    };

    mkDarwinConfiguration = host:
      darwin.lib.darwinSystem {
        inherit (host) system;
        specialArgs = mkSpecialArgs host;
        modules = [
          ./hosts/${host.hostname}
          home-manager.darwinModules.home-manager
          {home-manager = mkHomeManager host;}
        ];
      };

    mkNixosConfiguration = host:
      nixpkgs.lib.nixosSystem {
        inherit (host) system;
        specialArgs = mkSpecialArgs host;
        modules = [
          ./hosts/${host.hostname}
          home-manager.nixosModules.home-manager
          {home-manager = mkHomeManager host;}
        ];
      };
  in {
    darwinConfigurations.Diamond = mkDarwinConfiguration hosts.Diamond;
    nixosConfigurations.Bort = mkNixosConfiguration hosts.Bort;

    formatter = lib.genAttrs (map (host: host.system) (builtins.attrValues hosts)) (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
