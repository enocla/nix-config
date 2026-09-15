{...}: {
  homebrew = {
    enable = true;

    # taps = [ ];

    brews = [
      "elio"
      "sichengchen/tap/apple-calendar-cli"
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
    ];

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
  };
}
