{
  description = "Nix configurations for Diamond and Bort";

  inputs = {
    # Shared package set
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # System, home, and secrets management
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS desktop
    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";

    paneru = {
      url = "github:enocla/paneru/9fff52c238b7a1f6f6a7149ff554f462c8e8b33f";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Linux desktop and device integration
    # Preserve upstream package sets for binary/cache compatibility; do not
    # add follows here without checking the affected package builds.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    tether = {
      url = "github:zackb/tether";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae/11f58c008d62fa10fe364a6010f5b5f8f8200a56";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    # These inputs intentionally retain their upstream package-set pins.
    codex-desktop-linux.url = "github:ilysenko/codex-desktop-linux";
    nixcord.url = "github:4evy/nixcord";

    opencode-v2 = {
      url = "github:anomalyco/opencode/v2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  }: let
    inherit (nixpkgs) lib;
    hosts = import ./config/host.nix;
    systems = lib.unique (map (host: host.system) (builtins.attrValues hosts));
    theme = import ./lib/theme.nix {inherit lib;};
    mkSpecialArgs = host: {inherit inputs host theme;};

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

    packages = lib.genAttrs systems (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = package:
          builtins.elem (lib.getName package) ["berkeley-mono-nerd-font" "sf-pro-text"];
      };
    in
      lib.filterAttrs (_: package: lib.meta.availableOn pkgs.stdenv.hostPlatform package)
      (import ./pkgs {inherit pkgs;}));

    checks = lib.genAttrs systems (system:
      import ./checks {
        pkgs = nixpkgs.legacyPackages.${system};
        nixosUsername = hosts.Bort.username;
        nixosConfig =
          if system == hosts.Bort.system
          then self.nixosConfigurations.Bort.config
          else null;
        darwinConfig =
          if system == hosts.Diamond.system
          then self.darwinConfigurations.Diamond.config
          else null;
      });

    formatter = lib.genAttrs systems (
      system: nixpkgs.legacyPackages.${system}.alejandra
    );
  };
}
