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

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
  };

  programs.codexDesktopLinux.enable = true;

  system.stateVersion = host.systemStateVersion;
}
