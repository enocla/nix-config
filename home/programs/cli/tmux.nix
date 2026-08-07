{
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  # Script to auto-attach to a directory-based session
  list-cmd = "tmux list-sessions -F '#{session_name}\t#{pane_current_command}\t#{pane_current_path}'";
  tmux-picker = pkgs.writeShellScriptBin "tmux-session-picker" ''
    ${list-cmd} \
      | awk -F'\t' '{printf "%-20s  %-12s  %s\n", $1, $2, $3}' \
      | fzf --reverse --no-border \
        --prompt=' ' \
        --color='bg:${c.crust},bg+:${c.surface0},fg+:${c.text},hl:${c.yellow},hl+:${c.yellow},pointer:${c.mauve},prompt:${c.green},info:${c.overlay1},border:${c.surface1},label:${c.mauve},header:${c.overlay1},spinner:${c.green},marker:${c.green},query:${c.text},gutter:-1' \
        --border=bold \
        --border-label=' Sessions ' --border-label-pos=2 \
        --preview-label=' Preview ' --preview-label-pos=2 \
        --preview='tmux capture-pane -ep -t {1} 2>/dev/null || echo "No preview available"' \
        --preview-window='right,60%,border-bold' \
        --bind='ctrl-/:abort' \
        --bind="ctrl-x:execute-silent(tmux kill-session -t {1})+reload(${list-cmd} | awk -F'\t' '{printf \"%-20s  %-12s  %s\n\", \$1, \$2, \$3}')" \
        --header='ctrl-x: kill session' \
      | awk '{print $1}' \
      | xargs -I{} tmux switch-client -t '{}'
  '';
  tmux-dir = pkgs.writeShellScriptBin "t" ''
    dir="''${1:-$(pwd)}"
    dir="$(cd "$dir" && pwd)"
    name="$(basename "$dir" | tr '.' '-')"
    if [ -n "$TMUX" ]; then
      old="$(tmux display-message -p '#{session_name}')"
      if ! tmux has-session -t "=$name" 2>/dev/null; then
        tmux new-session -ds "$name" -c "$dir"
      fi
      tmux switch-client -t "=$name"
      if [ "$old" != "$name" ]; then
        tmux kill-session -t "=$old"
      fi
    else
      if tmux has-session -t "=$name" 2>/dev/null; then
        exec tmux attach-session -t "=$name"
      else
        exec tmux new-session -s "$name" -c "$dir"
      fi
    fi
  '';
in {
  home.packages = [tmux-dir tmux-picker];
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    mouse = true;
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
    ];
    extraConfig = ''
      # Renumber windows so cmd+1-9 stays positional
      set -g renumber-windows on

      # Windows
      bind t new-window -c "#{pane_current_path}"
      bind q detach-client
      bind w kill-pane
      bind , previous-window
      bind . next-window

      # Splits
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind Left select-pane -L
      bind Down select-pane -D
      bind Up select-pane -U
      bind Right select-pane -R

      # Pane resize (repeatable)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Layout
      bind = select-layout tiled

      # Keep sessions alive with no attached clients
      set -g destroy-unattached off
      # When a session is destroyed, switch to another instead of detaching
      set -g detach-on-destroy off
      # Keep tmux server alive even with no sessions
      set -g exit-empty off
      # If all sessions die, create a fresh one so the client doesn't exit
      set-hook -g session-closed 'if-shell "test $(tmux list-sessions 2>/dev/null | wc -l) -eq 0" "new-session -d -s main"'

      # Bells
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # Kitty integration — true color + extended keys (CSI u)
      set -ag terminal-overrides ",xterm-kitty:Tc"
      set -g extended-keys-format csi-u
      set -g extended-keys on
      set -as terminal-features 'xterm-kitty:extkeys'
      set -g allow-passthrough on
      set -g focus-events on

      # Clock mode
      setw -g clock-mode-colour "${c.yellow}"

      # Copy mode
      setw -g mode-style "fg=${c.base} bg=${c.red} bold"

      # Panes
      set -g pane-border-style "fg=${c.surface1}"
      set -g pane-active-border-style "fg=${c.green}"

      # Statusbar
      set -g status-justify left
      set -g status-style "fg=${c.text} bg=${c.mantle}"
      set -g status-left ""
      set -g status-left-length 10
      set -g status-right-style "fg=${c.base} bg=${c.green}"
      set -g status-right " #S "
      set -g status-right-length 50
      set -g @scroll-speed-num-lines-per-scroll "1"
      set -g status-position top
      setw -g window-status-current-style "fg=${c.base} bg=${c.mauve}"
      setw -g window-status-current-format " #I #W #F "
      setw -g window-status-style "fg=${c.overlay1} bg=${c.surface0}"
      setw -g window-status-format " #I #[fg=${c.text}]#W #[fg=${c.yellow}]#F "
      setw -g window-status-bell-style "fg=${c.yellow} bg=${c.red} bold"

      # Messages
      set -g message-style "fg=${c.yellow} bg=${c.surface0} bold"
    '';
  };
}
