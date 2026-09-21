{
  config,
  host,
  pkgs,
  theme,
  ...
}: let
  c = theme.colors;
  inherit (theme.ui) cornerRadius;
  noctaliaSession = pkgs.writeShellApplication {
    name = "noctalia-session";
    runtimeInputs = [config.programs.noctalia.package pkgs.matugen pkgs.pywal pkgs.coreutils];
    text = ''
      exec noctalia --daemon
    '';
  };
in {
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
          layout "us"
        }
        repeat-delay 250
        repeat-rate 33
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
        proportion 0.83
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

    spawn-at-startup "${noctaliaSession}/bin/noctalia-session"
    spawn-sh-at-startup "for i in 1 2 3 4 5; do sleep 1; noctalia msg wallpaper-set ${host.homeDirectory}/Pictures/phos.webp && exit 0; done"

    hotkey-overlay {
      skip-at-startup
    }
    prefer-no-csd

    // Niri built-in switcher (with live previews), Super+Tab only.
    // Defining binds here disables the Alt+Tab defaults.
    // Mod = Super (Windows key), i.e. the Linux equivalent of Cmd.
    recent-windows {
      highlight {
        active-color "${c.mauve}"
        urgent-color "${c.red}"
        padding 24
        corner-radius ${toString cornerRadius}
      }
      binds {
        Mod+Tab { next-window; }
        Mod+Shift+Tab { previous-window; }
      }
    }

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
    debug {
      honor-xdg-activation-with-invalid-serial
    }

    binds {
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Shift+O hotkey-overlay-title=null { spawn "obsidian"; }
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
      Mod+Ctrl+Alt+R hotkey-overlay-title="Screenshot" { spawn-sh "noctalia msg screenshot-region"; }
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

      Mod+Ctrl+Alt+1 { focus-workspace 1; }
      Mod+Ctrl+Alt+2 { focus-workspace 2; }
      Mod+Ctrl+Alt+3 { focus-workspace 3; }
      Mod+Ctrl+Alt+4 { focus-workspace 4; }
      Mod+Ctrl+Alt+5 { focus-workspace 5; }
      Mod+Ctrl+Alt+6 { focus-workspace 6; }
      Mod+Ctrl+Alt+7 { focus-workspace 7; }
      Mod+Ctrl+Alt+8 { focus-workspace 8; }
      Mod+Ctrl+Alt+9 { focus-workspace 9; }
      Mod+Ctrl+Alt+Shift+1 { move-window-to-workspace 1; }
      Mod+Ctrl+Alt+Shift+2 { move-window-to-workspace 2; }
      Mod+Ctrl+Alt+Shift+3 { move-window-to-workspace 3; }
      Mod+Ctrl+Alt+Shift+4 { move-window-to-workspace 4; }
      Mod+Ctrl+Alt+Shift+5 { move-window-to-workspace 5; }
      Mod+Ctrl+Alt+Shift+6 { move-window-to-workspace 6; }
      Mod+Ctrl+Alt+Shift+7 { move-window-to-workspace 7; }
      Mod+Ctrl+Alt+Shift+8 { move-window-to-workspace 8; }
      Mod+Ctrl+Alt+Shift+9 { move-window-to-workspace 9; }

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
