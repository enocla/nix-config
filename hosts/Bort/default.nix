{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "Bort";

  system.stateVersion = "26.05";
}
