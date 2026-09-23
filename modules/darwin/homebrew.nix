{...}: {
  homebrew = {
    enable = true;

    brews = [
      "elio"
      "sichengchen/tap/apple-calendar-cli"
      "keith/formulae/reminders-cli"
      "r"
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
      "reminders-menubar"
      "vicinae"
    ];

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
  };
}
