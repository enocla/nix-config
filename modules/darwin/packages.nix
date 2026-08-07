{
  pkgs,
  system,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # Migrated to malt (see ~/Developer/shaw). Commented-out entries are now
  # installed via `malt install`; `# → malt: <name>` marks a renamed formula.
  # Entries left ACTIVE have no malt equivalent and must stay with nix.
  environment.systemPackages = with pkgs; [
    # typst                 # → malt

    # CLI & Shell
    # bat                   # → malt
    # btop                  # → malt
    # chafa                 # → malt
    comma # no malt equivalent (nix-only)
    # coreutils             # → malt (GNU tools are g-prefixed: gls, gdate;
    #                       #   add /opt/malt/opt/coreutils/libexec/gnubin for unprefixed)
    # claude-code # malt: unsupported cask format (bare binary, not .dmg/.zip/.pkg)
    # delta                 # → malt: git-delta
    # direnv                # → malt
    # dua                   # → malt: dua-cli
    # eza                   # → malt
    # fastfetch             # → malt
    # fd                    # → malt
    # fish                  # → malt
    # fzf                   # → malt
    # gh                    # → malt
    # git                   # → malt
    # git-crypt             # → malt
    # git-lfs               # → malt
    # hyperfine             # → malt
    # jq                    # → malt
    # jujutsu               # → malt: jj
    # kitty                 # → malt (cask)
    # lazygit               # → malt
    # lazyjj                # → malt
    # mosh                  # → malt
    nh # no malt equivalent (nix-only)
    nix-output-monitor # no malt equivalent (nix-only)
    # nowplaying-cli        # → malt
    # pdfcpu                # → malt
    # ripgrep               # → malt
    # sd                    # → malt
    # pm2 # no malt equivalent
    # starship              # → malt
    # tldr                  # → malt
    # tmux                  # → malt
    # tokei                 # → malt
    # tree-sitter           # → malt
    # wget                  # → malt
    # zoxide                # → malt
    # gemini-cli            # → malt
    # charm-freeze

    # Code Editors & IDEs
    # neovim                # → malt
    # vscode                # → malt: visual-studio-code (cask)

    # Build Tools & Task Runners
    # cmake                 # → malt
    # just                  # → malt
    # meson                 # → malt
    # ninja                 # → malt
    # watch                 # → malt
    # act

    # Languages & Package Managers
    # cargo-binstall        # → malt
    # clang-tools # no malt equivalent; llvm is keg-only so clangd/clang-tidy
    #   would not land on PATH. Keep until /opt/malt/opt/llvm/bin is wired up.
    # go                    # → malt (already installed there)
    # llvm                  # → malt (keg-only: /opt/malt/opt/llvm/bin)
    # lua                   # → malt
    # micropython           # → malt
    nixd # no malt equivalent (nix-only)
    nrr # no malt equivalent
    # pnpm                  # → malt
    # python3               # → malt: python@3.14
    #
    # rustup is installed via malt, but ships NO TOOLCHAIN. Before removing
    # this, run:  rustup default nightly && rustup component add rust-src
    # (rust-bin.nightly.latest.default.override {
    #   extensions = ["rust-src"];
    # })
    # uv                    # → malt
    # yarn                  # → malt
    # zig                   # → malt
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
    # libavif               # → malt
    # libsoundio            # → malt
    # spirv-tools

    # Media Tools
    # ffmpeg                # → malt (already installed there)
    # iina                  # → malt (cask)
    # motrix-next           # → malt: motrix (cask)
    # yt-dlp

    # Previously bun globals, now in nixpkgs
    # assemblyscript # no malt equivalent
    # biome                 # → malt
    # opencode              # → malt

    # Code Quality & Formatting
    # stylua                # → malt
    # swiftformat           # → malt
    # topiary               # → malt
    # ast-grep

    # Development Tools - macOS
    # darwin.lsusb          # → malt: lsusb
    # switchaudio-osx       # → malt
    # xcodegen              # → malt

    # Apps
    # shottr                # → malt (cask)
    # blender               # → malt (cask)
    # vesktop  # fails to build on macOS (codesign not available in sandbox)

    # Containerization
    # colima                # → malt
    # docker                # → malt
    # ollama                # → malt

    # Compression & Archives
    # xz                    # → malt (on disk as a dependency, not a direct install)
    # zlib                  # → malt

    # Network Tools
    # nmap                  # → malt
  ];
}
