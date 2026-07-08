{
  pkgs,
  system,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    typst

    # CLI & Shell
    bat
    btop
    chafa
    comma
    coreutils
    claude-code
    delta
    direnv
    dua
    eza
    fastfetch
    fd
    fish
    fzf
    gh
    git
    git-crypt
    git-lfs
    hyperfine
    jq
    jujutsu
    kitty
    lazygit
    lazyjj
    mosh
    nh
    nix-output-monitor
    nowplaying-cli
    pdfcpu
    ripgrep
    sd
    pm2
    starship
    tldr
    tmux
    tokei
    tree-sitter
    wget
    zoxide
    gemini-cli
    # charm-freeze

    # Code Editors & IDEs
    neovim
    vscode

    # Build Tools & Task Runners
    cmake
    just
    meson
    ninja
    watch
    # act

    # Languages & Package Managers
    cargo-binstall
    clang-tools
    go
    llvm
    lua
    micropython
    nixd
    nrr
    pnpm
    python3
    (rust-bin.nightly.latest.default.override {
      extensions = ["rust-src"];
    })
    uv
    yarn
    zig
    # elixir
    # gleam
    # conan

    # WebAssembly
    # wasmer
    # wasmtime

    # Graphics & Multimedia Libraries
    # glfw
    # glm
    # glslang
    # raylib
    # SDL2
    libavif
    libsoundio
    # spirv-tools

    # Media Tools
    ffmpeg
    iina
    motrix-next
    # yt-dlp

    # Previously bun globals, now in nixpkgs
    assemblyscript
    biome
    opencode

    # Code Quality & Formatting
    stylua
    swiftformat
    topiary
    # ast-grep

    # Development Tools - macOS
    darwin.lsusb
    switchaudio-osx
    xcodegen

    # Apps
    ice-bar
    obsidian
    shottr
    blender
    # vesktop  # fails to build on macOS (codesign not available in sandbox)

    # Containerization
    colima
    docker
    ollama

    # Compression & Archives
    xz
    zlib

    # Network Tools
    nmap
  ];
}
