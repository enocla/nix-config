{
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  dcd = pkgs.stdenvNoCC.mkDerivation {
    pname = "dcd";
    version = "1.1.0";
    src = pkgs.fetchzip {
      url = "https://github.com/boyter/dcd/releases/download/v1.1.0/dcd-1.0.0-x86_64-unknown-linux.zip";
      hash = "sha256-f64Ji2m7o/HLe35L83DnlSzeY/g2Ez8ZBIzHmkO0v9I=";
    };
    installPhase = ''
      runHook preInstall
      install -Dm755 dcd "$out/bin/dcd"
      runHook postInstall
    '';
  };

  prism = pkgs.stdenvNoCC.mkDerivation {
    pname = "prism";
    version = "1.4.1";
    src = pkgs.fetchzip {
      url = "https://github.com/DaltonSW/prism/releases/download/v1.4.1/prism_Linux_x86_64.tar.gz";
      hash = "sha256-wM+vNtSP+6h3+Q7OwExYTkQGgYCkkCrO19a/lrieYKc=";
      stripRoot = false;
    };
    installPhase = ''
      runHook preInstall
      install -Dm755 prism "$out/bin/prism"
      runHook postInstall
    '';
  };

  mkElectronWrapper = {
    package,
    binaries,
  }:
    pkgs.symlinkJoin {
      name = "${lib.getName package}-wrapped";
      paths = [package];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild =
        lib.concatMapStringsSep "\n" (binary: ''
          wrapProgram "$out/bin/${binary}" \
            --set ELECTRON_OZONE_PLATFORM_HINT auto
        '')
        binaries;
      meta = package.meta // {mainProgram = builtins.head binaries;};
    };

  obsidianWrapped = mkElectronWrapper {
    package = pkgs.obsidian;
    binaries = ["obsidian"];
  };

  discordWrapped = mkElectronWrapper {
    package = pkgs.discord;
    binaries = ["Discord" "discord"];
  };

  commonPackages = with pkgs; [
    vscode
    aria2
    btop
    chafa
    clang-tools
    coreutils
    delta
    docker
    dua
    eza
    ffmpeg
    gcc
    git
    git-crypt
    git-lfs
    gnupg
    gzip
    lame
    lazygit
    lazyjj
    libogg
    libsoundio
    libvmaf
    libvorbis
    libvpx
    llvm
    lua
    lzo
    mosh
    nickel
    nmap
    opus
    sdl2-compat
    sdl3
    svt-av1
    tealdeer
    tmux
    tomlplusplus
    unixtools.watch
    wget
    libwebp
    x264
    x265
    yaml-cpp
    yarn
    zlib
  ];

  darwinPackages = with pkgs; [
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

  linuxPackages = with pkgs; [
    astro-language-server
    bash-language-server
    biome
    bluetui
    brightnessctl
    bun
    cargo
    cargo-binstall
    claude-agent-acp
    claude-code
    clippy
    cmake
    codex-acp
    colima
    cosign
    curl
    dcd
    deno
    eog
    fastfetch
    flameshot
    fd
    gh
    gnome-themes-extra
    go
    go-tools
    gopls
    gotools
    gradle
    gum
    helix
    hunk
    hyperfine
    jq
    kdePackages.breeze
    kdePackages.breeze-icons
    kdePackages.dolphin
    kdePackages.kcalc
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.qtsvg
    just
    kcl
    kotlin
    labwc
    lima
    lisette
    lua-language-server
    maven
    meson
    mpv
    pkgs.matugen
    nautilus
    neovim
    ninja
    nodejs
    opam
    opencode
    pkl
    pnpm
    prism
    protobuf
    pyright
    pywal
    playerctl
    ripgrep
    ruff
    rust-analyzer
    rustc
    rustfmt
    sd
    sfwbar
    stylua
    svelte-language-server
    swiftformat
    tailwindcss-language-server
    tokei
    trash-cli
    tree-sitter
    typst
    usage
    usbutils
    uv
    vscode-langservers-extracted
    vtsls
    vue-language-server
    waybar
    wl-clipboard
    wiremix
    xwayland-satellite
    yaml-language-server
    yt-dlp
    zig
    zed-editor
    kiro-cli
    yazi
    obsidianWrapped
    discordWrapped
    comma
    samba
    cifs-utils
  ];
in {
  environment.systemPackages =
    commonPackages
    ++ lib.optionals isDarwin darwinPackages
    ++ lib.optionals isLinux linuxPackages;
}
