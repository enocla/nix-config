{
  lib,
  matugen,
  pkgs,
  ...
}: let
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

  pythonEnv = pkgs.python3.withPackages (pythonPackages:
    with pythonPackages; [
      fuse
      jsonpickle
      pyicloud
      pyyaml
    ]);

  icloudLinux = pkgs.stdenvNoCC.mkDerivation {
    pname = "icloud-linux";
    version = "unstable-2026-08-18";
    src = pkgs.fetchFromGitHub {
      owner = "IsmaeelAkram";
      repo = "icloud-linux";
      rev = "acf8f7a8b704bb0e01259895e7100d2b76251662";
      hash = "sha256-1X7vSpbJkTb0iSZQMpnNJILQaTth/cJRvwtF/mRbank=";
    };
    nativeBuildInputs = [pkgs.makeWrapper];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      install -d "$out/libexec/icloud-linux" "$out/bin"
      cp -- *.py config.example.yaml icloudctl "$out/libexec/icloud-linux/"
      chmod +x "$out/libexec/icloud-linux/icloudctl"

      # Use immutable Nix dependencies while leaving credentials, cookies,
      # cache, and the generated user service in the user's home directory.
      substituteInPlace "$out/libexec/icloud-linux/icloudctl" \
        --replace-fail 'ensure_venv() {' 'ensure_venv() { return 0; # dependencies are supplied by Nix' \
        --replace-fail '"$REPO_DIR/.venv/bin/python"' '${pythonEnv}/bin/python' \
        --replace-fail '/usr/bin/fusermount' '/run/wrappers/bin/fusermount'

      makeWrapper "$out/libexec/icloud-linux/icloudctl" "$out/bin/icloudctl" \
        --prefix PATH : "/run/wrappers/bin:${lib.makeBinPath [pkgs.systemd pythonEnv]}"
      runHook postInstall
    '';
    meta.mainProgram = "icloudctl";
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
in {
  # accli and xcodegen require macOS APIs and cannot run on Bort.
  environment.systemPackages = with pkgs; [
    kitty
    aria2
    astro-language-server
    bash-language-server
    bat
    biome
    bluetui
    brightnessctl
    btop
    bun
    cargo
    cargo-binstall
    chafa
    clang-tools
    claude-agent-acp
    claude-code
    clippy
    cmake
    codex-acp
    colima
    coreutils
    cosign
    curl
    dcd
    deno
    direnv
    docker
    dua
    eza
    eog
    fastfetch
    flameshot
    fd
    ffmpeg
    font-awesome
    fish
    fzf
    gcc
    gh
    git
    git-crypt
    git-lfs
    delta
    gnupg
    gnome-themes-extra
    go
    go-tools
    gopls
    gotools
    gradle
    gum
    gzip
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
    jujutsu
    kcl
    kotlin
    lame
    lazygit
    labwc
    libogg
    libsoundio
    libvmaf
    libvorbis
    libvpx
    lima
    lisette
    llvm
    lua
    lua-language-server
    lzo
    maven
    meson
    mosh
    mpv
    matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    nautilus
    neovim
    nickel
    ninja
    nmap
    nodejs
    opam
    opencode
    opus
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
    sdl2-compat
    sdl3
    starship
    stylua
    svelte-language-server
    svt-av1
    swiftformat
    tailwindcss-language-server
    tealdeer
    tmux
    tokei
    tomlplusplus
    trash-cli
    tree-sitter
    typst
    unixtools.watch
    usage
    usbutils
    uv
    vscode-langservers-extracted
    vtsls
    vue-language-server
    waybar
    wl-clipboard
    wiremix
    libwebp
    wget
    x264
    x265
    xwayland-satellite
    yaml-cpp
    yaml-language-server
    yarn
    yt-dlp
    zig
    zlib
    zoxide
    zed-editor
    kiro-cli
    icloudLinux
    yazi
    obsidianWrapped
    discordWrapped
  ];
}
