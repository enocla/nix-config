{darwin-custom-icons, ...}: {
  imports = [
    ../../modules/darwin

    ../../modules/icons
    darwin-custom-icons.darwinModules.default

    ./paneru.nix
  ];
}
