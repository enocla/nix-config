{
  lib,
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  primaryModifier =
    if isDarwin
    then "cmd"
    else "super";
  shell =
    if isDarwin
    then "/opt/malt/bin/fish"
    else "${pkgs.fish}/bin/fish";
in {
  xdg.configFile."kitty/tab_bar.py".source = ./tab_bar.py;
  xdg.configFile."kitty/theme_colors.json".text = builtins.toJSON theme.colors;

  # Keep a user-local application entry so launchers such as Vicinae can find Kitty
  # even when the package itself comes from the system profile.
  xdg.dataFile."applications/kitty.desktop" = lib.mkIf (!isDarwin) {
    text = ''
      [Desktop Entry]
      Type=Application
      Version=1.5
      Name=Kitty
      GenericName=Terminal Emulator
      Comment=Fast, feature-rich, GPU based terminal
      Exec=${pkgs.kitty}/bin/kitty
      Icon=kitty
      Terminal=false
      Categories=System;TerminalEmulator;
      StartupWMClass=kitty
    '';
  };

  xdg.configFile."kitty/kitty.conf".text = ''
    font_family ${theme.ui.fontFamily}
    font_size 14

    url_style straight
    allow_remote_control yes
    shell_integration enabled
    scrollback_lines 10000

    window_padding_width 0
    window_padding_height 0

    hide_window_decorations titlebar-only

    # Tab bar (custom, see tab_bar.py)
    tab_bar_edge top
    tab_bar_style custom
    tab_bar_align left
    tab_bar_min_tabs 1

    # Tab colors (used by draw_title in tab_bar.py)
    tab_bar_background ${c.base}
    active_tab_foreground ${c.crust}
    active_tab_background ${c.rosewater}
    active_tab_font_style bold
    inactive_tab_foreground ${c.subtext0}
    inactive_tab_background ${c.base}
    inactive_tab_font_style normal

    cursor_shape underline

    shell ${shell}

    ${lib.optionalString isDarwin ''
      macos_option_as_alt yes
      macos_colorspace displayp3
    ''}

    paste_actions quote-urls-at-prompt,confirm-if-large
    copy_on_select yes

    foreground ${c.text}
    background ${c.base}
    selection_foreground none
    selection_background ${c.surface2}

    cursor ${c.rosewater}
    cursor_text_color ${c.crust}

    url_color ${c.rosewater}

    active_border_color ${c.lavender}
    inactive_border_color ${c.overlay1}
    bell_border_color ${c.yellow}

    wayland_titlebar_color system
    macos_titlebar_color system

    background_opacity 0.95
    background_blur 24

    mark1_foreground ${c.crust}
    mark1_background ${c.lavender}

    mark2_foreground ${c.crust}
    mark2_background ${c.mauve}

    mark3_foreground ${c.crust}
    mark3_background ${c.sky}

    color0 ${c.surface1}
    color8 ${c.surface2}

    color1 ${c.red}
    color9 ${c.red}

    color2 ${c.green}
    color10 ${c.green}

    color3 ${c.yellow}
    color11 ${c.yellow}

    color4 ${c.blue}
    color12 ${c.blue}

    color5 ${c.pink}
    color13 ${c.pink}

    color6 ${c.sapphire}
    color14 ${c.sapphire}

    color7 ${c.subtext1}
    color15 ${c.subtext0}

    disable_ligatures always

    modify_font underline_thickness 100%
    modify_font underline_position 3
    modify_font baseline 0.5
    modify_font cell_height 172%

    # Tab management
    map ${primaryModifier}+t new_tab_with_cwd
    map ${primaryModifier}+w close_tab
    map ${primaryModifier}+1 goto_tab 1
    map ${primaryModifier}+2 goto_tab 2
    map ${primaryModifier}+3 goto_tab 3
    map ${primaryModifier}+4 goto_tab 4
    map ${primaryModifier}+5 goto_tab 5
    map ${primaryModifier}+6 goto_tab 6
    map ${primaryModifier}+7 goto_tab 7
    map ${primaryModifier}+8 goto_tab 8
    map ${primaryModifier}+9 goto_tab 9
    map ctrl+tab next_tab
    map ctrl+shift+tab previous_tab

    # Window management
    map ${primaryModifier}+shift+w close_window

    # Tab navigation
    map ${primaryModifier}+up previous_tab
    map ${primaryModifier}+down next_tab
    map ${primaryModifier}+shift+n new_tab_with_cwd

    # Clipboard helper
    map ${primaryModifier}+f launch --type=overlay --stdin-source=@screen_scrollback /bin/sh -c 'fzf --no-sort --no-mouse --exact -i --tac | tr -d "\n" | kitty +kitten clipboard'
  '';
}
