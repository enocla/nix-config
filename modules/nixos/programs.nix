{pkgs, ...}: {
  programs = {
    steam.enable = true;

    fish.enable = true;
    helium = {
      enable = false;
      flags = ["--ozone-platform-hint=auto"];
    };
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
