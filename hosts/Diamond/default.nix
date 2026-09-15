{darwin-custom-icons, ...}: {
  imports = [
    ../../modules/base
    ../../modules/darwin

    ../../modules/icons
    darwin-custom-icons.darwinModules.default

    ./paneru.nix
  ];
}
