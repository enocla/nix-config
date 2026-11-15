{pkgs, ...}: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    steam.enable = true;

    fish.enable = true;
    niri.enable = true;
    # Backend for Noctalia's screen_recorder plugin. The setcap gsr-kms-server
    # wrapper lets region/monitor capture start without a polkit prompt.
    gpu-screen-recorder = {
      enable = true;
    };
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
