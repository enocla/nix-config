{...}: {
  imports = [
    ./fonts.nix
    ./packages.nix
    ./users.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
