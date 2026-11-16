{pkgs}: {
  dcd = pkgs.callPackage ./dcd {};
  "inter-theme" = pkgs.callPackage ./inter-theme {};
  "berkeley-mono-nerd-font" = pkgs.callPackage ./berkeley-mono-nerd-font {};
  "sf-pro-text" = pkgs.callPackage ./sf-pro-text {};
  "nordwand-mono" = pkgs.callPackage ./nordwand-mono {};
  "iowan-old-style" = pkgs.callPackage ./iowan-old-style {};
  "macos-tahoe-cursor" = pkgs.callPackage ./macos-tahoe-cursor {};
}
