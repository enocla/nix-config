{
  config,
  dms,
  lib,
  matugen,
  noctalia,
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) cornerRadius fontFamily;
  wallpaper = ../../../extra/wallpaper/phos.webp;
  matugenPackage = matugen.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  # Keep DMS available as an input/module, but use Noctalia for this Linux host.
  imports = [
    dms.homeModules.dank-material-shell
    noctalia.homeModules.default
  ];

  programs.dank-material-shell = {
    enable = lib.mkForce false;
    systemd.enable = false;
  };

  home.packages = [matugenPackage pkgs.pywal];

  home.sessionVariables.QS_ICON_THEME = "breeze-dark";

  home.file = {
    ".icons/default".source = "${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Classic";
    "Pictures/phos.webp".source = wallpaper;
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    font = {
      name = fontFamily;
      size = 13;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    qt5ctSettings.Fonts = {
      fixed = "\"${fontFamily},13\"";
      general = "\"${fontFamily},13\"";
    };
    qt6ctSettings.Fonts = {
      fixed = "\"${fontFamily},13\"";
      general = "\"${fontFamily},13\"";
    };
  };

  services.polkit-gnome.enable = true;
  systemd.user.services.polkit-gnome = {
    Service = {
      Restart = "on-failure";
      RestartSec = 1;
    };
    Unit = {
      StartLimitIntervalSec = 30;
      StartLimitBurst = 10;
    };
  };

  programs.noctalia = {
    enable = true;
    settings = {
      bar.default = {
        margin_edge = 0;
        margin_ends = 0;
        position = "left";
        radius = 0;
        scale = 1.15;
        thickness = 36;
      };
      hooks.wallpaper_changed = ''
        wal --cols16 -i "$NOCTALIA_WALLPAPER_PATH" & matugen image "$NOCTALIA_WALLPAPER_PATH" --opacity 0.85 --source-color-index 0
      '';
      location.auto_locate = true;
      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = ["lockscreen-login-box@eDP-1"];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget."lockscreen-login-box@eDP-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 960.0;
          cy = 961.0;
          output = "eDP-1";
          rotation = 0.0;
          type = "login_box";
          settings = {
            background_color = "surface_variant";
            background_opacity = 0.88;
            background_radius = 12.0;
            input_opacity = 1.0;
            input_radius = 6.0;
            show_login_button = true;
          };
        };
      };
      nightlight.enabled = true;
      shell.font_family = fontFamily;
      theme = {
        builtin = "Catppuccin";
        community_palette = "Oxocarbon";
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
        templates.builtin_ids = ["niri"];
      };
      wallpaper.directory = "${config.home.homeDirectory}/Pictures";
    };
  };

  # Keep the reference Waybar/Labwc configuration available even though Noctalia
  # is the default shell and panel for Niri.
  programs.waybar = {
    enable = true;
    settings.bar = {
      height = 24;
      layer = "top";
      spacing = 0;
      position = "bottom";
      modules-left = ["niri/workspaces" "niri/language"];
      modules-center = ["niri/window"];
      modules-right = [
        "tray"
        "wireplumber"
        "network"
        "bluetooth"
        "backlight"
        "clock"
        "battery"
        "battery#bat2"
        "custom/power"
      ];
      "niri/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        warp-on-scroll = false;
        format = "{icon}";
      };
      tray.spacing = 10;
      "niri/language".format = "{short}";
      clock.tooltip-format = "<big>{:%Y %B}</big>\\n<tt><small>{calendar}</small></tt>";
      backlight = {
        format = "{icon} {percent}%";
        format-icons = ["" "" "" "" "" "" "" "" ""];
      };
      battery = {
        bat = "BAT0";
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-full = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-icons = ["" "" "" "" ""];
      };
      "battery#bat2" = {
        bat = "BAT1";
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-full = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-icons = ["" "" "" "" ""];
      };
      bluetooth = {
        format = "";
        format-off = "󰂲";
        on-click = "kitty --hold sh -c 'bluetui'";
      };
      network = {
        format-wifi = " {essid}";
        format-disconnected = "󰖪";
        on-click = "kitty --hold sh -c 'nmtui'";
      };
      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰖁";
        format-icons.default = ["" "" ""];
        on-click = "kitty --hold sh -c 'wiremix'";
      };
      "custom/power" = {
        format = "⏻";
        on-click = "systemctl suspend";
      };
    };
    style = ''
      * {
        font-family: ${fontFamily};
        font-size: 13pt;
        transition-property: background-color;
        transition-duration: .25s;
      }
      window#waybar {
        background-color: ${c.base};
        color: ${c.text};
      }
      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: ${toString cornerRadius};
        margin: 2px 2px;
      }
      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
      }
      #workspaces button.focused, #workspaces button.active {
        background-color: ${c.mauve};
        color: ${c.crust};
      }
      #language, #tray, #bluetooth, #wireplumber, #network, #backlight,
      #clock, #battery, #custom-power {
        margin: 2px 2px;
        padding: 0 10px;
        color: ${c.text};
        border-radius: ${toString cornerRadius};
      }
      #battery, #bluetooth, #wireplumber, #custom-power, #network {
        background-color: ${c.surface1};
      }
      #custom-power { background-color: ${c.mauve}; color: ${c.crust}; }
    '';
  };

  xdg.configFile."labwc/rc.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <labwc_config>
      <keyboard>
        <keybind key="C-A-J"><action name="NextWindow" /></keybind>
        <keybind key="C-A-K"><action name="PreviousWindow" /></keybind>
        <keybind key="C-A-Space"><action name="ShowMenu" menu="client-list-combined-menu" /></keybind>
        <keybind key="C-A-H"><action name="SnapToEdge" direction="left" /></keybind>
        <keybind key="C-A-L"><action name="SnapToEdge" direction="right" /></keybind>
        <keybind key="C-A-F"><action name="ToggleMaximize" /></keybind>
        <keybind key="C-A-Q"><action name="Close" /></keybind>
      </keyboard>
    </labwc_config>
  '';

  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.niri]
    input_path = '~/.config/matugen/templates/niri-colors.kdl'
    output_path = '~/.config/niri/colors.kdl'

    [templates.waybar]
    input_path = '~/.config/matugen/templates/colors.css'
    output_path = '~/.config/waybar/colors.css'

    [templates.gtk3]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-3.0/colors.css'

    [templates.gtk4]
    input_path = '~/.config/matugen/templates/gtk-colors.css'
    output_path = '~/.config/gtk-4.0/colors.css'
  '';
  xdg.configFile."matugen/templates/niri-colors.kdl".text = ''
    layout {
      focus-ring {
        active-color "{{colors.primary.default.hex}}"
        inactive-color "{{colors.outline.default.hex}}"
        urgent-color "{{colors.error.default.hex}}"
      }
      border {
        active-color "{{colors.primary.default.hex}}"
        inactive-color "{{colors.outline.default.hex}}"
        urgent-color "{{colors.error.default.hex}}"
      }
      shadow { color "{{colors.shadow.default.hex}}70" }
    }
  '';
  xdg.configFile."matugen/templates/colors.css".text = ''
    <* for name, value in colors *>
    @define-color {{name}} {{value.default.hex}};
    <* endfor *>
  '';
  xdg.configFile."matugen/templates/gtk-colors.css".text = ''
    @define-color accent_color {{colors.primary_fixed_dim.default.rgba}};
    @define-color accent_fg_color {{colors.on_primary_fixed.default.rgba}};
    @define-color accent_bg_color {{colors.primary_fixed_dim.default.rgba}};
    @define-color window_bg_color {{colors.surface_dim.default.rgba}};
    @define-color window_fg_color {{colors.on_surface.default.rgba}};
    @define-color view_bg_color {{colors.surface.default.rgba}};
    @define-color view_fg_color {{colors.on_surface.default.rgba}};
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = "org.gnome.eog.desktop";
      "image/jpg" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "document/pdf" = "org.kde.okular.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
    };
  };

  xdg.configFile."niri/config-nix.kdl".text = ''
    window-rule {
      geometry-corner-radius ${toString cornerRadius}
      clip-to-geometry true
    }
  '';

  xdg.configFile."niri/config.kdl".text = ''
    include "./config-nix.kdl"

    input {
      keyboard {
        xkb {
          layout "us,ru"
          options "grp:caps_toggle"
        }
        repeat-delay 250
        repeat-rate 25
      }
      touchpad {
        tap
        natural-scroll
      }
      mouse {
        accel-profile "flat"
      }
      trackpoint {
        accel-profile "flat"
      }
      warp-mouse-to-focus
      focus-follows-mouse max-scroll-amount="95%"
    }

    environment {
      XDG_CURRENT_DESKTOP "niri"
      QT_QPA_PLATFORM "wayland"
      ELECTRON_OZONE_PLATFORM_HINT "auto"
      QT_QPA_PLATFORMTHEME "gtk3"
      QT_QPA_PLATFORMTHEME_QT6 "gtk3"
    }

    output "eDP-1" {
      mode "1920x1080@60"
      scale 1
      transform "normal"
    }

    layout {
      gaps 8
      always-center-single-column
      background-color "transparent"
      center-focused-column "never"
      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }
      default-column-width { proportion 0.5; }
      focus-ring {
        width 3
        active-color "${c.mauve}"
        inactive-color "${c.surface1}"
      }
      border {
        off
      }
      shadow {
        off
      }
    }

    spawn-at-startup "noctalia" "--daemon"
    spawn-sh-at-startup "for i in 1 2 3 4 5; do sleep 1; noctalia msg wallpaper-set ${config.home.homeDirectory}/Pictures/phos.webp && exit 0; done"

    hotkey-overlay {
      skip-at-startup
    }
    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    layer-rule {
      match namespace="^noctalia-backdrop"
      place-within-backdrop true
    }
    layer-rule {
      match namespace="^noctalia-(background|launcher-overlay|dock)-.*$"
      background-effect {
        xray false
      }
    }

    window-rule {
      clip-to-geometry true
      draw-border-with-background false
      background-effect {
        blur true
      }
    }
    window-rule {
      match app-id="^zen$" title="^Picture-in-Picture$"
      open-floating true
    }

    debug {
      honor-xdg-activation-with-invalid-serial
    }

    binds {
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Shift+G hotkey-overlay-title=null { spawn "godot-mono"; }
      Mod+Shift+O hotkey-overlay-title=null { spawn "obsidian"; }
      Mod+Shift+F hotkey-overlay-title=null { spawn-sh "zen"; }
      Mod+Shift+T hotkey-overlay-title=null { spawn-sh "Telegram"; }
      Mod+Shift+C hotkey-overlay-title=null { spawn "kitty"; }
      Mod+Shift+D hotkey-overlay-title=null { spawn-sh "labwc -s sfwbar"; }
      Mod+E hotkey-overlay-title=null { spawn "nautilus"; }

      // Noctalia replaces DMS as the panel, launcher, and settings shell.
      Mod+A { spawn-sh "noctalia msg panel-toggle wallpaper"; }
      Mod+P { spawn-sh "noctalia msg panel-toggle launcher"; }
      Mod+S { spawn-sh "noctalia msg settings-toggle"; }

      // Keep the existing Vicinae integration available alongside Noctalia.
      Mod+Space hotkey-overlay-title="Application Launcher" { spawn "vicinae" "toggle"; }
      Ctrl+E hotkey-overlay-title="Clipboard History" {
        spawn "vicinae" "deeplink" "vicinae://launch/clipboard/history?toggle=true";
      }

      // Existing terminal and Paneru-style bindings.
      Mod+Ctrl+Alt+Return hotkey-overlay-title="Kitty" { spawn "kitty"; }
      Mod+Q { close-window; }
      Mod+Ctrl+Alt+H { focus-column-left; }
      Mod+Ctrl+Alt+Q { focus-column-left; }
      Mod+Ctrl+Alt+J { focus-window-down; }
      Mod+Ctrl+Alt+K { focus-window-up; }
      Mod+Ctrl+Alt+L { focus-column-right; }
      Mod+Ctrl+Alt+E { focus-column-right; }
      Mod+Ctrl+Alt+Left { move-column-left; }
      Mod+Ctrl+Alt+Right { move-column-right; }
      Mod+Ctrl+Alt+Up { move-window-up; }
      Mod+Ctrl+Alt+Down { move-window-down; }
      Mod+Ctrl+Alt+A { move-column-to-monitor-up; }
      Mod+Ctrl+Alt+D { move-column-to-monitor-down; }
      Alt+C { center-column; }
      Alt+F { maximize-column; }
      Alt+R { switch-preset-column-width; }
      Mod+Ctrl+Alt+Equal { set-column-width "+10%"; }
      Mod+Ctrl+Alt+Minus { set-column-width "-10%"; }
      Alt+BracketLeft { consume-or-expel-window-left; }
      Alt+BracketRight { consume-or-expel-window-right; }
      Mod+Ctrl+Alt+Escape { toggle-window-floating; }

      // Reference Niri navigation and workspace bindings.
      Mod+O repeat=false { toggle-overview; }
      Mod+C repeat=false { close-window; }
      Mod+Left { focus-column-left; }
      Mod+Down { focus-window-down; }
      Mod+Up { focus-window-up; }
      Mod+Right { focus-column-right; }
      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }
      Mod+Shift+Left { move-column-left; }
      Mod+Shift+Down { move-window-down; }
      Mod+Shift+Up { move-window-up; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }
      Mod+Shift+L { move-column-right; }
      Mod+Home { focus-column-first; }
      Mod+End { focus-column-last; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End { move-column-to-last; }
      Mod+Ctrl+Left { focus-monitor-left; }
      Mod+Ctrl+Down { focus-monitor-down; }
      Mod+Ctrl+Up { focus-monitor-up; }
      Mod+Ctrl+Right { focus-monitor-right; }
      Mod+Ctrl+H { focus-monitor-left; }
      Mod+Ctrl+J { focus-monitor-down; }
      Mod+Ctrl+K { focus-monitor-up; }
      Mod+Ctrl+L { focus-monitor-right; }

      Ctrl+1 { focus-workspace 1; }
      Ctrl+2 { focus-workspace 2; }
      Ctrl+3 { focus-workspace 3; }
      Ctrl+4 { focus-workspace 4; }
      Ctrl+5 { focus-workspace 5; }
      Ctrl+6 { focus-workspace 6; }
      Ctrl+7 { focus-workspace 7; }
      Ctrl+8 { focus-workspace 8; }
      Ctrl+9 { focus-workspace 9; }
      Ctrl+Shift+1 { move-window-to-workspace 1; }
      Ctrl+Shift+2 { move-window-to-workspace 2; }
      Ctrl+Shift+3 { move-window-to-workspace 3; }
      Ctrl+Shift+4 { move-window-to-workspace 4; }
      Ctrl+Shift+5 { move-window-to-workspace 5; }
      Ctrl+Shift+6 { move-window-to-workspace 6; }
      Ctrl+Shift+7 { move-window-to-workspace 7; }
      Ctrl+Shift+8 { move-window-to-workspace 8; }
      Ctrl+Shift+9 { move-window-to-workspace 9; }

      XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"; }
      XF86AudioMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      XF86AudioMicMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
      XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
      XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
      XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
      XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }
      XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+5%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "5%-"; }
    }
  '';
}
