{
  config,
  dms,
  theme,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) cornerRadius fontFamily;
  dmsPalette = {
    name = "nix-config";
    primary = c.mauve;
    primaryText = c.crust;
    primaryContainer = c.surface2;
    secondary = c.blue;
    surface = c.base;
    surfaceText = c.text;
    surfaceVariant = c.surface1;
    surfaceVariantText = c.subtext1;
    surfaceTint = c.mauve;
    background = c.base;
    backgroundText = c.text;
    outline = c.overlay1;
    surfaceContainer = c.mantle;
    surfaceContainerHigh = c.surface0;
    error = c.red;
    warning = c.yellow;
    info = c.sky;
  };
in {
  imports = [dms.homeModules.dank-material-shell];

  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    settings = {
      currentThemeName = "custom";
      currentThemeCategory = "generic";
      customThemeFile = "${config.xdg.configHome}/DankMaterialShell/theme.json";
      inherit cornerRadius fontFamily;
      monoFontFamily = fontFamily;
    };
  };

  # The upstream HM unit does not set PATH, but dms launches qs and helpers by name.
  systemd.user.services.dms.Service.Environment = [
    "PATH=${config.home.homeDirectory}/.local/state/nix/profiles/home-manager/home-path/bin:/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin"
  ];

  xdg.configFile."DankMaterialShell/theme.json".text = builtins.toJSON {
    dark = dmsPalette;
    light = dmsPalette;
  };

  xdg.configFile."niri/config.kdl".text = ''
    // Window bindings are mirrored from home/config/paneru/paneru.toml.
    input {
        keyboard {
            xkb {}
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    environment {
        XDG_CURRENT_DESKTOP "niri"
        QT_QPA_PLATFORM "wayland"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        QT_QPA_PLATFORMTHEME "gtk3"
        QT_QPA_PLATFORMTHEME_QT6 "gtk3"
    }

    layout {
        gaps 12
        background-color "transparent"
        center-focused-column "on-overflow"
        preset-column-widths {
            proportion 0.333
            proportion 0.5
            proportion 0.667
            proportion 0.8
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            width 3
            active-color "${c.mauve}"
            inactive-color "${c.surface1}"
        }
    }

    layer-rule {
        match namespace="^quickshell$"
        place-within-backdrop true
    }

    layer-rule {
        match namespace="^dms:blurwallpaper$"
        place-within-backdrop true
    }

    window-rule {
        geometry-corner-radius ${toString cornerRadius}
        clip-to-geometry true
    }

    window-rule {
        match app-id=r#"^org\.quickshell$"#
        open-floating true
    }

    prefer-no-csd

    hotkey-overlay {
        skip-at-startup
    }

    binds {
        // macOS-style system bindings: Super is the Cmd equivalent on Linux.
        Mod+Return { spawn "kitty"; }
        Mod+Q { close-window; }

        // Vicinae is the primary application launcher; DMS Spotlight remains available.
        Mod+Space hotkey-overlay-title="Application Launcher" {
            spawn "vicinae" "toggle";
        }
        Mod+Shift+Space hotkey-overlay-title="DMS Spotlight" {
            spawn "dms" "ipc" "call" "spotlight" "toggle";
        }
        Mod+V hotkey-overlay-title="Clipboard Manager" {
            spawn "dms" "ipc" "call" "clipboard" "toggle";
        }
        Mod+M hotkey-overlay-title="Task Manager" {
            spawn "dms" "ipc" "call" "processlist" "focusOrToggle";
        }
        Mod+Comma hotkey-overlay-title="DMS Settings" {
            spawn "dms" "ipc" "call" "settings" "focusOrToggle";
        }
        Mod+N hotkey-overlay-title="Notification Center" {
            spawn "dms" "ipc" "call" "notifications" "toggle";
        }
        Mod+P hotkey-overlay-title="Notepad" {
            spawn "dms" "ipc" "call" "notepad" "toggle";
        }
        Mod+Y hotkey-overlay-title="Browse Wallpapers" {
            spawn "dms" "ipc" "call" "dankdash" "wallpaper";
        }
        Mod+X hotkey-overlay-title="Power Menu" {
            spawn "dms" "ipc" "call" "powermenu" "toggle";
        }
        Mod+Alt+L hotkey-overlay-title="Lock Screen" {
            spawn "dms" "ipc" "call" "lock" "lock";
        }
        Mod+Alt+N hotkey-overlay-title="Night Mode" {
            spawn "dms" "ipc" "call" "night" "toggle";
        }
        XF86AudioRaiseVolume allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "increment" "3";
        }
        XF86AudioLowerVolume allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "decrement" "3";
        }
        XF86AudioMute allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "mute";
        }
        XF86AudioMicMute allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "micmute";
        }
        XF86MonBrightnessUp allow-when-locked=true {
            spawn "dms" "ipc" "call" "brightness" "increment" "5" "";
        }
        XF86MonBrightnessDown allow-when-locked=true {
            spawn "dms" "ipc" "call" "brightness" "decrement" "5" "";
        }

        // Paneru focus bindings.
        Mod+Ctrl+Alt+H { focus-column-left; }
        Mod+Ctrl+Alt+Q { focus-column-left; }
        Mod+Ctrl+Alt+J { focus-window-down; }
        Mod+Ctrl+Alt+K { focus-window-up; }
        Mod+Ctrl+Alt+L { focus-column-right; }
        Mod+Ctrl+Alt+E { focus-column-right; }

        // Paneru swap bindings.
        Mod+Ctrl+Alt+Left { move-column-left; }
        Mod+Ctrl+Alt+Right { move-column-right; }
        Mod+Ctrl+Alt+Up { move-window-up; }
        Mod+Ctrl+Alt+Down { move-window-down; }
        Mod+Ctrl+Alt+A { move-column-to-monitor-up; }
        Mod+Ctrl+Alt+D { move-column-to-monitor-down; }

        // Paneru position, resize, stack, and floating bindings.
        Alt+C { center-column; }
        Alt+F { maximize-column; }
        Alt+R { switch-preset-column-width; }
        Mod+Ctrl+Alt+Equal { set-column-width "+10%"; }
        Mod+Ctrl+Alt+Minus { set-column-width "-10%"; }
        Alt+BracketLeft { consume-or-expel-window-left; }
        Alt+BracketRight { consume-or-expel-window-right; }
        Mod+Ctrl+Alt+Escape { toggle-window-floating; }

        // Paneru virtual workspace bindings.
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
    }
  '';
}
