{pkgs, ...}: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    steam.enable = true;

    fish.enable = true;
    niri.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
