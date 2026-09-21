{
  host,
  inputs,
  ...
}: {
  imports = [
    ../../modules/darwin

    ../../modules/darwin/icons
    inputs.darwin-custom-icons.darwinModules.default

    ./paneru.nix
  ];

  networking.hostName = host.hostname;
}
