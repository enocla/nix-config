{...}: {
  # Enter nix-shell / nix develop / nix shell in fish (with the normal
  # config, prompt, abbreviations, etc.) instead of a bare bash.
  programs.nix-your-shell = {
    enable = true;
    enableFishIntegration = true;
  };
}
