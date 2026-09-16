{
  determinate,
  helium,
  tether,
  ...
}: {
  imports = [
    determinate.nixosModules.default
    helium.nixosModules.default
    tether.nixosModules.default
  ];
}
