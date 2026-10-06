{inputs, ...}: {
  imports = [inputs.vscode-server.nixosModules.default];

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    vscode-server.enable = true;
  };
}
