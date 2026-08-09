{theme, ...}: let
  c = theme.colors;
  strip = theme.rawHexValue;
in {
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      function off
        command $argv &>/dev/null &
        disown
      end

      fish_vi_key_bindings

      function __expand_dots
        set -l levels (math (string length $argv[1]) - 1)
        string repeat -n $levels "../"
      end

      abbr --add --regex '^\.\.{2,}$' -f __expand_dots dots

      # Color Palette from theme.nix
      set -l foreground ${strip c.text}
      set -l selection  ${strip c.surface1}
      set -l comment    ${strip c.overlay0}
      set -l red        ${strip c.red}
      set -l orange     ${strip c.peach}
      set -l yellow     ${strip c.yellow}
      set -l green      ${strip c.green}
      set -l purple     ${strip c.mauve}
      set -l cyan       ${strip c.sky}
      set -l pink       ${strip c.pink}

      # Syntax Highlighting Colors
      set -g fish_color_normal $foreground
      set -g fish_color_command $green
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_option $pink
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment

      # Completion Pager Colors
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment
      set -g fish_pager_color_selected_background --background=$selection

      # Disable greeting
      set -g fish_greeting

      # Key bindings (must specify -M insert for vi mode)
      bind -M insert \eh backward-word
      bind -M insert \el forward-word
      bind -M insert \e\x7f backward-kill-word

      eval "$(/Users/tnixc/.local/bin/mise activate fish)"
    '';
  };
}
