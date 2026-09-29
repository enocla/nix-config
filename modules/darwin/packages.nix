{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    blender
    google-chrome
    iina
    maple-mono.NF
    maple-mono.Normal-NF-CN
    nowplaying-cli
    pinentry_mac
    prismlauncher
    shottr
    switchaudio-osx
  ];
}
