{
  pkgs,
  inputs,
  ...
}: let
  customPkgs = import ../../pkgs {inherit pkgs;};

  # Upstream nix/opencode.nix still generates shell completions by shelling out
  # to `opencode completion`, but the CLI dropped that subcommand when it moved
  # off yargs onto its own Effect-based command framework. The bare word now
  # falls through to the default handler, which runs `process.chdir("completion")`
  # and dies with ENOENT, failing installPhase. There is no completion generator
  # left to call, so drop the stale step instead of papering over it.
  # Drop this overrideAttrs once upstream's flake packaging is fixed.
  opencode = inputs.opencode-v2.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (
    _old: {
      postInstall = "";
    }
  );
  elio = inputs.elio.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  environment.systemPackages = with pkgs;
    [
      astro-language-server
      bash-language-server
      biome
      bluetui
      brightnessctl
      bun
      cargo
      cargo-binstall
      cifs-utils
      claude-agent-acp
      claude-code
      clippy
      cmake
      colima
      comma
      cosign
      curl
      customPkgs.dcd
      deno
      eog
      fastfetch
      fd
      fuse
      gh
      gnome-themes-extra
      go
      go-tools
      google-chrome
      gopls
      gotools
      gradle
      gum
      herdr
      hunk
      hyperfine
      customPkgs.icloud-linux
      jq
      just
      kcl
      kdePackages.breeze
      kdePackages.breeze-icons
      kdePackages.dolphin
      kdePackages.kcalc
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kio-fuse
      kdePackages.qtsvg
      kiro-cli
      kotlin
      labwc
      lima
      lisette
      lua-language-server
      maven
      meson
      mpv
      nautilus
      neovim
      ninja
      nodejs
      obsidian
      opam
      pkl
      playerctl
      pnpm
      customPkgs.prism
      protobuf
      pyright
      ripgrep
      ruff
      rust-analyzer
      rustc
      rustfmt
      samba
      sd
      sfwbar
      stylua
      svelte-language-server
      swiftformat
      tailwindcss-language-server
      tokei
      tree-sitter
      typst
      unzip
      usage
      usbutils
      uv
      vscode-langservers-extracted
      vtsls
      vue-language-server
      wiremix
      wl-clipboard
      xwayland-satellite
      yaml-language-server
      yazi
      yt-dlp
      zed-editor
      zig
      zip
      t3code
      pkg-config
      fontconfig
      dejavu_fonts
      python3
    ]
    ++ [elio opencode];
}
