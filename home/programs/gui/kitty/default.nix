{
  lib,
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  # keyd swaps Ctrl and Super on Linux: physical Cmd arrives as Ctrl and
  # physical Ctrl arrives as Super.
  primaryModifier =
    if isDarwin
    then "cmd"
    else "ctrl";
  controlModifier =
    if isDarwin
    then "ctrl"
    else "super";

  # Undo the swap inside the terminal so programs see the physical modifier:
  # Super+key becomes a real Ctrl+key (control codes, SIGINT, readline), and
  # Ctrl+key becomes Super+key. send_key encodes for the program's current
  # keyboard mode (legacy or kitty protocol). The macOS-style actions below
  # are mapped afterwards and take precedence over the Ctrl fallbacks.
  swapKeys =
    lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz0123456789"
    ++ ["grave" "minus" "equal" "[" "]" "backslash" "semicolon" "apostrophe" "comma" "period" "slash"]
    ++ ["space" "enter" "tab" "backspace" "delete" "escape" "insert" "home" "end" "page_up" "page_down" "up" "down" "left" "right"]
    ++ map (n: "f${toString n}") (lib.range 1 12);
  # keyd already turns Option/Cmd+arrows into Ctrl+arrows, Home/End and
  # Ctrl+Home/End. Those Ctrl chords must reach the terminal unchanged.
  navigationKeys = ["up" "down" "left" "right" "home" "end" "page_up" "page_down"];
  # kitty's default kitty_mod shortcuts (kitty_mod = physical Ctrl+Shift,
  # as on macOS). These keys keep the kitty action instead of being
  # forwarded to the program.
  kittyModKeys =
    lib.stringToCharacters "abcefghjklnopqrstuvwxz0123456789"
    ++ ["grave" "minus" "equal" "[" "]" "comma" "period" "slash"]
    ++ ["escape" "enter" "backspace" "delete" "left" "right" "up" "down" "home" "end" "page_up" "page_down"]
    ++ ["f1" "f2" "f3" "f5" "f6" "f7" "f8" "f10" "f11"];
  isKittyModDefault = mods: key:
    (mods == "shift+" && lib.elem key kittyModKeys)
    || (mods == "alt+shift+" && key == "t");
  swapMods = ["" "shift+" "alt+" "alt+shift+"];
  modifierSwap = lib.concatMapStringsSep "\n" (mods:
    lib.concatMapStringsSep "\n" (key:
      lib.concatStringsSep "\n" (
        lib.optional (!isKittyModDefault mods key) "map super+${mods}${key} send_key ctrl+${mods}${key}"
        ++ lib.optional (!lib.elem key navigationKeys) "map ctrl+${mods}${key} send_key super+${mods}${key}"
      ))
    swapKeys)
  swapMods;
  shell =
    if isDarwin
    then "${pkgs.fish}/bin/fish"
    else "${pkgs.fish}/bin/fish";
in {
  # Kitty owns its package and therefore its package-provided desktop entry.
  home.packages = [pkgs.kitty];

  xdg.configFile."kitty/tab_bar.py".source = ./tab_bar.py;
  xdg.configFile."kitty/theme_colors.json".text = builtins.toJSON theme.colors;

  xdg.configFile."kitty/kitty.conf".text = ''
    font_family ${theme.ui.monospaceFontFamily}
    font_size ${
      if isDarwin
      then "14"
      else "12"
    }

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

    ${lib.optionalString (!isDarwin) ''
      kitty_mod super+shift
      ${modifierSwap}

      # keyd sends Option+Backspace as Ctrl+Backspace and Cmd+Backspace as
      # Shift+Home, Backspace. Give the shell the usual terminal codes.
      map ctrl+backspace send_key alt+backspace
      map shift+home send_key ctrl+u

      # Cmd+click opens links.
      mouse_map ctrl+left release grabbed,ungrabbed mouse_handle_click link
      mouse_map ctrl+left press grabbed discard_event
    ''}

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
    map ${primaryModifier}+n new_os_window
    map ${primaryModifier}+enter new_window
    map ${primaryModifier}+shift+w close_window
    map ${primaryModifier}+q quit

    # Tab navigation
    map ${primaryModifier}+up previous_tab
    map ${primaryModifier}+down next_tab
    map ${primaryModifier}+shift+n new_tab_with_cwd
    map ${primaryModifier}+shift+[ previous_tab
    map ${primaryModifier}+shift+] next_tab
    map ${primaryModifier}+alt+left previous_tab
    map ${primaryModifier}+alt+right next_tab

    # The macOS defaults also need explicit bindings on Linux.
    map ${primaryModifier}+c copy_to_clipboard
    map ${primaryModifier}+v paste_from_clipboard
    map ${primaryModifier}+equal change_font_size all +2.0
    map ${primaryModifier}+shift+equal change_font_size all +2.0
    map ${primaryModifier}+minus change_font_size all -2.0
    map ${primaryModifier}+shift+minus change_font_size all -2.0
    map ${primaryModifier}+0 change_font_size all 0
    map ${primaryModifier}+k clear_terminal to_cursor active
    map ${primaryModifier}+alt+k clear_terminal scrollback active
    map ${primaryModifier}+l clear_terminal last_command active
    map ${primaryModifier}+${controlModifier}+l clear_terminal to_cursor_scroll active
    map ${primaryModifier}+r start_resizing_window
    map ${primaryModifier}+alt+r clear_terminal reset active
    map ${primaryModifier}+comma edit_config_file
    map ${primaryModifier}+${controlModifier}+comma load_config_file
    map ${primaryModifier}+alt+comma debug_config
    map ${primaryModifier}+shift+i set_tab_title
    map ${primaryModifier}+home scroll_home
    map ${primaryModifier}+end scroll_end
    map ${primaryModifier}+page_up scroll_page_up
    map ${primaryModifier}+page_down scroll_page_down

    # Clipboard helper
    map ${primaryModifier}+f launch --type=overlay --stdin-source=@screen_scrollback /bin/sh -c 'fzf --no-sort --no-mouse --exact -i --tac | tr -d "\n" | kitty +kitten clipboard'
  '';
}
