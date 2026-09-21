{pkgs, ...}: let
  customPkgs = import ../../pkgs {inherit pkgs;};
in {
  fonts.packages = [
    customPkgs."berkeley-mono-nerd-font"
    customPkgs."sf-pro-text"
    pkgs.nerd-fonts.symbols-only
  ];
}
