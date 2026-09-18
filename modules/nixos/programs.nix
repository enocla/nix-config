{pkgs, ...}: {
  programs = {
    fish.enable = true;
    helium = {
      enable = true;
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
