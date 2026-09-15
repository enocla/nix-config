{...}: {
  homebrew = {
    enable = true;

    brews = [
      "elio"
      "sichengchen/tap/apple-calendar-cli"
      "keith/formulae/reminders-cli"
    ];

    casks = [
      "codex"
      "craft"
      "helium-browser"
      "linearmouse"
      "microsoft-teams"
      "microsoft-word"
      "motrix"
      "nordvpn"
      "parsec"
      "bettercmdtab"
      "abue-ammar/tinycast/tinycast"
    ];

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
  };
}
