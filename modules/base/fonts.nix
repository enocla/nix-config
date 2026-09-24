{pkgs, ...}: let
  customPkgs = import ../../pkgs {inherit pkgs;};
in {
  fonts.packages = [
    pkgs.crimson-pro
    customPkgs."berkeley-mono-nerd-font"
    customPkgs."sf-pro-text"
    pkgs.nerd-fonts.symbols-only
  ];
}
