{
  description = "Nix for macOS configuration";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://nix-community.cachix.org"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];

    http-connections = 128;
    max-substitution-jobs = 128;
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin-custom-icons.url = "github:ryanccn/nix-darwin-custom-icons";

    paneru = {
      url = "git+file:///Users/tnixc/Developer/paneru?ref=focusnum";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    nixpkgs-darwin,
    home-manager,
    darwin,
    darwin-custom-icons,
    paneru,
    ...
  }: let
    hostConfig = import ./config/host.nix;
    inherit (hostConfig) hostname username system gpgKey configRepoName;

    inherit (inputs.nixpkgs-darwin) lib;
    theme = import ./lib/theme.nix {inherit lib;};
    colorMix = import ./lib/color-mix.nix;

    specialArgs =
      inputs
      // {
        inherit username system theme colorMix configRepoName gpgKey;
      };
  in {
    darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        {
          nixpkgs.overlays = [
            (_final: prev: let
              externalZshPlugin = name:
                prev.runCommand "external-${name}-999.0.0" {} ''
                  mkdir -p "$out/share"
                  ln -s /opt/malt/share/${name} "$out/share/${name}"
                '';
            in {
              # Home Manager sources these plugin trees by absolute store path.
              zsh-autosuggestions = externalZshPlugin "zsh-autosuggestions";
              zsh-history-substring-search = externalZshPlugin "zsh-history-substring-search";
              zsh-syntax-highlighting = externalZshPlugin "zsh-syntax-highlighting";
            })
          ];
        }
        ./modules/base
        ./modules/darwin
        ./modules/host-users.nix
        darwin-custom-icons.darwinModules.default
        ./modules/icons

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "backup";
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./home;
        }
      ];
    };

    # nix code formatter
    formatter.${system} = nixpkgs-darwin.legacyPackages.${system}.alejandra;
  };
}
