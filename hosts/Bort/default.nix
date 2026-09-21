{
  host,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.codex-desktop-linux.nixosModules.default
  ];

  networking.hostName = host.hostname;

  programs.codexDesktopLinux.enable = true;

  system.stateVersion = host.systemStateVersion;
}
