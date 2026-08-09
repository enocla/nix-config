{
  theme,
  config,
  ...
}: let
  c = theme.colors;
in {
  xdg.configFile."ghostty/config".text = ''
    # Font
    font-family = BerkeleyMono Nerd Font
    font-size = 14

    # disable_ligatures always
    font-feature = -liga
    font-feature = -calt
    font-feature = -dlig

    # modify_font underline_position 3
    adjust-underline-position = 3
    # modify_font cell_height 172%
    adjust-cell-height = 72%

    # Shell
    command = /opt/malt/bin/fish
    shell-integration = fish

    # Scrollback (kitty: scrollback_lines 10000; ghostty limit is bytes)
    scrollback-limit = 10000000

    # URLs
    link-url = true

    # Clipboard (kitty: paste_actions confirm-if-large)
    clipboard-paste-protection = true

    # Window
    window-padding-x = 0
    window-padding-y = 0
    macos-titlebar-style = tabs
    macos-option-as-alt = true
    window-colorspace = display-p3
    background-opacity = 0.95
    background-blur = 24

    # Cursor
    cursor-style = underline

    # Theme colors
    background = ${c.base}
    foreground = ${c.text}
    selection-background = ${c.surface2}
    cursor-color = ${c.rosewater}
    cursor-text = ${c.crust}

    palette = 0=${c.surface1}
    palette = 8=${c.surface2}

    palette = 1=${c.red}
    palette = 9=${c.red}

    palette = 2=${c.green}
    palette = 10=${c.green}

    palette = 3=${c.yellow}
    palette = 11=${c.yellow}

    palette = 4=${c.blue}
    palette = 12=${c.blue}

    palette = 5=${c.pink}
    palette = 13=${c.pink}

    palette = 6=${c.sapphire}
    palette = 14=${c.sapphire}

    palette = 7=${c.subtext1}
    palette = 15=${c.subtext0}

    # Tab management
    keybind = super+t=new_tab
    keybind = super+w=close_tab
    keybind = super+one=goto_tab:1
    keybind = super+two=goto_tab:2
    keybind = super+three=goto_tab:3
    keybind = super+four=goto_tab:4
    keybind = super+five=goto_tab:5
    keybind = super+six=goto_tab:6
    keybind = super+seven=goto_tab:7
    keybind = super+eight=goto_tab:8
    keybind = super+nine=goto_tab:9
    keybind = ctrl+tab=next_tab
    keybind = ctrl+shift+tab=previous_tab

    # Window management
    keybind = super+shift+w=close_surface

    # Tab navigation
    keybind = super+up=previous_tab
    keybind = super+down=next_tab
    keybind = super+shift+n=new_tab
  '';
}
