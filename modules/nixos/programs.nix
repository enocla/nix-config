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
      # gsr assumes FFmpeg 9 needs NVENC API 13.1, which the 595 driver lacks
      # (it tops out at 13.0). FFmpeg 8 lowers gsr's check to 13.0. Drop this
      # once the production NVIDIA driver supports 13.1.
      package = pkgs.gpu-screen-recorder.override {ffmpeg = pkgs.ffmpeg_8;};
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
