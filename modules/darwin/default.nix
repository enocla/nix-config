{...}: {
  imports = [
    ../base
    ./environment
    ./homebrew.nix
    ./nix.nix
    ./packages.nix
    ./preferences
    ./security
    ./system.nix
  ];
}
