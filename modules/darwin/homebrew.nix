{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
      # Homebrew now refuses `brew bundle --cleanup` non-interactively unless one
      # of --force/--force-cleanup/$HOMEBREW_ASK is set. nix-darwin doesn't emit
      # one itself, so force the cleanup here.
      extraFlags = ["--force-cleanup"];
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    brews = [
      # CLI & tooling
      "aria2"
      "autoconf"
      "bjarneo/cliamp/cliamp"
      "brightness"
      "cliclick"
      "keith/formulae/reminders-cli"
      "lisette"
      "node"
      "opam"
      "openjdk"
      "xcode-build-server"
      "xcbeautify"
      "yt-dlp"
      "elio"

      # Compilers & formatters
      "clang-format"
      "gcc"
      "gdb"

      # Libraries
      "beast"
      "boost"
      "cmark-gfm"
      "fmt"
      "nlohmann-json"
      "re2"
      "tomlplusplus"
      "yaml-cpp"

      # Language runtimes
      "R"
      "kotlin"
      "gradle"
      "maven"
    ];

    # `brew install --cask`
    casks = [
      # Development
      "codex"
      "chatgpt"
      "zed"

      # System utilities
      "hammerspoon"
      "karabiner-elements"
      "linearmouse"

      # Apps
      # "ghostty"
      "anki"
      "craft"
      "google-chrome"
      "microsoft-teams"
      "microsoft-word"
      "nordvpn"
      "parsec"
      "prismlauncher"
      "Sanyam-G/switch/switch"
      "equibop"

      # Design assets
      "sf-symbols"

      # Fonts
      "font-maple-mono-nf"
      "font-maple-mono-normal-nf-cn"
      "font-sf-mono"
      "font-sf-pro"
    ];
  };
}
