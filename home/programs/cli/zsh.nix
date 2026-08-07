{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      # Re-source home-manager session vars after macOS /etc/zprofile path_helper reorders PATH
      if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';

    initContent = ''
      # Completion matching (case insensitive)
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Key bindings
      bindkey '^[h' backward-word
      bindkey '^[l' forward-word

      eval "$(/Users/tnixc/.local/bin/mise activate zsh)"
    '';
  };
}
