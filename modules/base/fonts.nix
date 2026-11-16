{pkgs, ...}: let
  customPkgs = import ../../pkgs {inherit pkgs;};
in {
  fonts.packages = [
    customPkgs."inter-theme"
    pkgs.crimson-pro
    pkgs.nerd-fonts.lilex
    customPkgs."berkeley-mono-nerd-font"
    customPkgs."sf-pro-text"
    customPkgs."nordwand-mono"
    customPkgs."iowan-old-style"
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.departure-mono
  ];
}
