{
  externalPackage,
  lib,
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  home.sessionVariables =
    {
      EDITOR = "nvim";
      PAGER = "bat";
      LLVM_PROFILE_FILE = "/dev/null";
      TERM = "xterm-256color";
      GUM_CONFIRM_PROMPT_FOREGROUND = c.text;
      GUM_CONFIRM_SELECTED_FOREGROUND = c.base;
      GUM_CONFIRM_SELECTED_BACKGROUND = c.mauve;
      GUM_CONFIRM_UNSELECTED_FOREGROUND = c.text;
      GUM_CONFIRM_UNSELECTED_BACKGROUND = c.surface0;
      GUM_INPUT_PROMPT_FOREGROUND = c.mauve;
      GUM_INPUT_CURSOR_FOREGROUND = c.rosewater;
      GUM_CHOOSE_CURSOR_FOREGROUND = c.rosewater;
      GUM_CHOOSE_SELECTED_FOREGROUND = c.mauve;
      GUM_CHOOSE_ITEM_FOREGROUND = c.text;
      GUM_FILTER_INDICATOR_FOREGROUND = c.mauve;
      GUM_FILTER_MATCH_FOREGROUND = c.red;
      GUM_FILTER_PROMPT_FOREGROUND = c.mauve;
      GUM_SPIN_SPINNER_FOREGROUND = c.rosewater;
    }
    // lib.optionalAttrs isDarwin {MALT_THEME = "everforest";};

  home.sessionPath =
    lib.optionals (!isDarwin) ["/run/wrappers/bin"]
    ++ [
      "/run/current-system/sw/bin"
      "/nix/var/nix/profiles/default/bin"
      "/etc/profiles/per-user/$USER/bin"
      "$HOME/.vite-plus/bin"
      "$HOME/.bun/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.craft/bin"
    ]
    ++ lib.optionals isDarwin [
      "/opt/malt/bin"
      "/usr/local/bin"
    ];

  home.shellAliases =
    {
      a = "nvim";
      q = "exit";
      cat = "bat";
      ga = "git add -A";
      lz = "lazygit";
      gz = "nvim +DiffviewOpen";
      g = "git";
      j = "just";
      gc = "git commit -m";
      ls = "eza --icons --group-directories-first";
      l = "eza --icons -la --no-user --no-time --no-permissions --git --group-directories-first";
      lr = "eza --icons -laR --git-ignore --git --no-user --no-time --no-permissions --group-directories-first";
      tree = "eza --icons --tree --git-ignore";
      treea = "eza --icons --tree -a";
      rm = "trash";
      rp = "realpath";
    }
    // lib.optionalAttrs isDarwin {
      f = "open .";
      bs = "brew services";
      icat = "kitten icat --align left";
      pcp = "pbcopy";
      ppy = "pbpaste";
    };

  programs.fzf = {
    enable = true;
    package = externalPackage "fzf" {
      binaries = [
        "fzf"
        "fzf-tmux"
      ];
    };
    enableZshIntegration = true;
    enableFishIntegration = true;
    colors = {
      "bg+" = c.surface0;
      spinner = c.rosewater;
      hl = c.red;
      fg = c.text;
      header = c.red;
      info = c.mauve;
      pointer = c.rosewater;
      marker = c.lavender;
      "fg+" = c.text;
      prompt = c.mauve;
      "hl+" = c.red;
      "selected-bg" = c.surface1;
    };
    defaultOptions = ["--multi"];
  };

  programs.zoxide = {
    enable = true;
    package = externalPackage "zoxide" {};
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
