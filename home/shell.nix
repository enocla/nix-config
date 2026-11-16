{
  lib,
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  # LS_COLORS uses decimal RGB channels rather than the theme's hex colors.
  foreground = color: let
    hex = theme.rawHexValue color;
    channels = map (
      offset: toString (lib.fromTOML "value = 0x${builtins.substring offset 2 hex}").value
    ) [0 2 4];
  in "38;2;${lib.concatStringsSep ";" channels}";

  lsColors = lib.concatStringsSep ":" (
    lib.mapAttrsToList (name: value: "${name}=${value}") {
      rs = "0";
      fi = foreground c.text;
      di = "1;${foreground c.blue}";
      ln = foreground c.teal;
      ex = foreground c.green;
      pi = foreground c.yellow;
      so = foreground c.pink;
      bd = foreground c.peach;
      cd = foreground c.peach;
      or = "1;${foreground c.red}";
      mi = foreground c.red;
      su = "1;${foreground c.red}";
      sg = "1;${foreground c.peach}";
      ca = foreground c.peach;
      mh = foreground c.text;
      st = "1;${foreground c.blue}";
      ow = "4;${foreground c.blue}";
      tw = "1;4;${foreground c.blue}";
    }
    ++ lib.concatMap (
      group: map (extension: "*.${extension}=${foreground group.color}") group.extensions
    ) [
      {
        color = c.peach;
        extensions = ["7z" "bz2" "gz" "rar" "tar" "tgz" "xz" "zip" "zst"];
      }
      {
        color = c.yellow;
        extensions = ["pdf" "epub" "md" "rst" "txt" "doc" "docx" "odt"];
      }
      {
        color = c.pink;
        extensions = ["avif" "gif" "heic" "ico" "jpeg" "jpg" "png" "svg" "webp"];
      }
      {
        color = c.mauve;
        extensions = ["avi" "m4v" "mkv" "mov" "mp4" "webm"];
      }
      {
        color = c.teal;
        extensions = ["aac" "flac" "m4a" "mp3" "ogg" "opus" "wav"];
      }
    ]
  );

  # `k`: search `ps aux` with fzf and kill the selected process(es).
  killProcess = pkgs.writeShellApplication {
    name = "k";
    runtimeInputs =
      [pkgs.fzf pkgs.gawk pkgs.coreutils]
      ++ lib.optionals (!isDarwin) [pkgs.procps];
    text = ''
      selection="$(ps aux | fzf --multi --reverse \
        --expect=ctrl-x \
        --header='ENTER: kill (SIGTERM)    CTRL-X: force kill (SIGKILL)' \
        --prompt='process > ' \
        --preview='ps -p {2} -o pid=,ppid=,user=,stat=,%cpu=,%mem=,etime=,command= 2>/dev/null || echo "Process no longer running"' \
        --preview-window='down,35%,border-bold,wrap')" || exit 0

      key="$(printf '%s\n' "$selection" | head -n 1)"
      matches="$(printf '%s\n' "$selection" | tail -n +2)"

      [ -n "$matches" ] || exit 0

      signal=TERM
      [ "$key" = ctrl-x ] && signal=KILL

      pids="$(printf '%s\n' "$matches" | awk '$2 ~ /^[0-9]+$/ {print $2}')"
      [ -n "$pids" ] || exit 0

      failed=0
      while IFS= read -r pid; do
        [ -n "$pid" ] || continue
        if kill "-$signal" "$pid" 2>/dev/null; then
          printf 'Sent SIG%s to PID %s\n' "$signal" "$pid"
        else
          printf 'Failed to kill PID %s (permission denied or already gone)\n' "$pid" >&2
          failed=1
        fi
      done <<< "$pids"

      exit "$failed"
    '';
  };
in {
  home.sessionVariables = {
    EDITOR = "nvim";
    LS_COLORS = lsColors;
    # PAGER = "bat";
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
  };

  # Refresh in every shell: an existing terminal may inherit Home Manager's
  # session-variable guard from before the latest theme deployment.
  programs.fish.shellInit = ''
    set -gx LS_COLORS ${lib.escapeShellArg lsColors}
  '';
  programs.zsh.envExtra = ''
    export LS_COLORS=${lib.escapeShellArg lsColors}
  '';
  programs.bash.initExtra = ''
    export LS_COLORS=${lib.escapeShellArg lsColors}
  '';

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
      "/opt/homebrew/bin"
      "/usr/local/bin"
    ];

  # Home Manager owns mise on Darwin and supplies shell integration from the
  # managed package. Project tools remain declared in extra/mise/config.toml.
  programs.mise = lib.mkIf isDarwin {
    enable = true;
    package = pkgs.mise;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  # The shared `rm` alias is backed by this package on both platforms.
  home.packages = [pkgs.trash-cli killProcess];

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
      icat = "kitten icat --align left";

      # CS 246
      "g++20h" = "g++ -std=c++20 -fmodules-ts -c -x c++-system-header";
      "g++20" = "g++ -std=c++20 -fmodules-ts -Wall -g";
    }
    // lib.optionalAttrs isDarwin {
      f = "open .";
      bs = "brew services";
      pcp = "pbcopy";
      ppy = "pbpaste";
    };

  programs.fzf = {
    enable = true;
    package = pkgs.fzf;
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
    package = pkgs.zoxide;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
