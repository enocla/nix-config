{...}: {
  homebrew = {
    enable = true;

    brews = [
      "elio"
      "sichengchen/tap/apple-calendar-cli"
      "keith/formulae/reminders-cli"
      "r"
      "pandoc"
    ];

    casks = [
      "rstudio"
      "codex"
      "helium-browser"
      "linearmouse"
      "microsoft-teams"
      "microsoft-word"
      "motrix"
      "nordvpn"
      "parsec"
      "bettercmdtab"
      "zed"
      "Sanyam-G/switch/switch"
      "raycast"
      "obsidian"
      "spotify"
    ];

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
  };
}
