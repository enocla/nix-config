{pkgs, ...}: let
  customPkgs = import ../../pkgs {inherit pkgs;};
in {
  fonts.packages = [
    pkgs.crimson-pro
    pkgs.nerd-fonts.lilex
    customPkgs."berkeley-mono-nerd-font"
    customPkgs."sf-pro-text"
    customPkgs."nordwand-mono"
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.departure-mono
  ];
}
