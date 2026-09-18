{
  pkgs,
  opencode-v2,
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

  icloudLinuxPython = pkgs.python3.withPackages (pythonPackages:
    with pythonPackages; [
      fuse
      jsonpickle
      pyicloud
      pyyaml
      rich
    ]);

  icloudLinux = pkgs.stdenvNoCC.mkDerivation {
    pname = "icloud-linux";
    version = "unstable-d2fa0ba";
    src = pkgs.fetchFromGitHub {
      owner = "IsmaeelAkram";
      repo = "icloud-linux";
      rev = "d2fa0bab7409c793861cf4c3ecb0a4e592464959";
      hash = "sha256-8RnUPYW74Vyl1ixoVIIio44flQbhpxTayQVo8vl1oW4=";
    };
    nativeBuildInputs = [pkgs.makeWrapper];

    installPhase = ''
            runHook preInstall
            install -d "$out/share/icloud-linux" "$out/bin"
            cp -R . "$out/share/icloud-linux/"

            # The upstream launcher bootstraps a mutable virtualenv. Nix provides
            # the complete runtime instead, while retaining the upstream CLI flow.
            substituteInPlace "$out/share/icloud-linux/icloudctl" \
              --replace-fail 'ensure_venv() {' 'ensure_venv() { :; return 0; } # disabled by Nix
            ensure_venv_legacy() {' \
              --replace-fail '$REPO_DIR/.venv/bin/python' '${icloudLinuxPython}/bin/python' \
              --replace-fail '/usr/bin/fusermount' '/run/wrappers/bin/fusermount' \
              --replace-fail 'cookie_dir: "$CONFIG_DIR/cookies"' 'cookie_dir: "$CONFIG_DIR/cookies"
      sync_paths:
        - /Obsidian'
            substituteInPlace "$out/share/icloud-linux/config.example.yaml" \
              --replace-fail 'cookie_dir: "~/.config/icloud-linux/cookies"' 'cookie_dir: "~/.config/icloud-linux/cookies"
      sync_paths:
        - /Obsidian'

            # Keep a stable wrapper in PATH while allowing the upstream script to
            # resolve its companion Python files from its immutable source tree.
            makeWrapper "$out/share/icloud-linux/icloudctl" "$out/bin/icloudctl"

            runHook postInstall
    '';
  };
in {
  environment.systemPackages = with pkgs;
    [
      fuse
      icloudLinux
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
      discord
      google-chrome
      obsidian
      comma
      samba
      cifs-utils
      herdr
    ]
    ++ [opencode-v2.packages.${pkgs.stdenv.hostPlatform.system}.default];
}
