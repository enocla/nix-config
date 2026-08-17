{
  config,
  externalPackage,
  ...
}: {
  programs.zsh = {
    enable = true;
    package = externalPackage "zsh" {
      binaryDir = "/bin";
      links = [
        {
          path = "share/zsh";
          target = "/usr/share/zsh";
        }
      ];
    };
    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Completion matching (case insensitive)
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # Key bindings
      bindkey '^[h' backward-word
      bindkey '^[l' forward-word

      if [ -x ${config.home.homeDirectory}/.local/bin/mise ]; then
        eval "$(${config.home.homeDirectory}/.local/bin/mise activate zsh)"
      fi
    '';
  };
}
