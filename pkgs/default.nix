{pkgs}: {
  dcd = pkgs.callPackage ./dcd {};
  prism = pkgs.callPackage ./prism {};
  "icloud-linux" = pkgs.callPackage ./icloud-linux {};
  "berkeley-mono-nerd-font" = pkgs.callPackage ./berkeley-mono-nerd-font {};
  "sf-pro-text" = pkgs.callPackage ./sf-pro-text {};
}
