{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    comma
    nh
    nix-output-monitor
    nixd
    nrr
  ];
}
