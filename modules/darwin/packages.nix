{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    blender
    google-chrome
    iina
    maple-mono.NF
    maple-mono.Normal-NF-CN
    nowplaying-cli
    orbstack
    pinentry_mac
    prismlauncher
    shottr
    switchaudio-osx
    vscode
  ];
}
