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

    // Niri built-in switcher, including windows of the current application.
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
        Mod+grave { next-window filter="app-id"; }
        Mod+Shift+grave { previous-window filter="app-id"; }
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
      // Keep compositor helpers on Hyper so Cmd shortcuts reach applications.
      Mod+Ctrl+Alt+Slash { show-hotkey-overlay; }
      Mod+Ctrl+Alt+Shift+O hotkey-overlay-title=null { spawn "obsidian"; }
      Mod+Ctrl+Alt+Shift+C hotkey-overlay-title=null { spawn "kitty"; }
      Mod+Ctrl+Alt+Shift+D hotkey-overlay-title=null { spawn-sh "labwc -s sfwbar"; }
      Mod+Ctrl+Alt+N hotkey-overlay-title="Files" { spawn "nautilus"; }

      // Noctalia replaces DMS as the panel, launcher, and settings shell.
      Mod+Ctrl+Alt+B { spawn "noctalia" "msg" "panel-toggle" "wallpaper"; }
      Mod+Ctrl+Alt+P { spawn "noctalia" "msg" "panel-toggle" "launcher"; }
      Mod+Ctrl+Alt+Comma { spawn "noctalia" "msg" "settings-toggle"; }

      // Keep the existing Vicinae integration available alongside Noctalia.
      Mod+Space hotkey-overlay-title="Application Launcher" { spawn "vicinae" "toggle"; }
      Mod+Ctrl+Alt+V hotkey-overlay-title="Clipboard History" {
        spawn "vicinae" "deeplink" "vicinae://launch/clipboard/history?toggle=true";
      }

      // macOS system shortcuts. keyd preserves these Cmd combinations.
      Mod+Ctrl+Q repeat=false hotkey-overlay-title="Lock Screen" { spawn "noctalia" "msg" "session" "lock"; }
      Mod+Ctrl+Space repeat=false hotkey-overlay-title="Emoji and Symbols" { spawn "noctalia" "msg" "panel-toggle" "launcher" "/emo"; }
      Mod+Ctrl+F repeat=false { fullscreen-window; }
      Mod+Shift+Q repeat=false hotkey-overlay-title="Log Out (Confirm)" { quit; }
      Mod+Alt+Escape repeat=false hotkey-overlay-title="Process Manager" { spawn "kitty" "-e" "btop"; }
      Mod+Alt+D repeat=false hotkey-overlay-title="Toggle Dock" { spawn "noctalia" "msg" "dock-toggle"; }
      Mod+Shift+3 repeat=false hotkey-overlay-title="Screenshot Screen" { screenshot-screen show-pointer=false; }
      Mod+Shift+4 repeat=false hotkey-overlay-title="Screenshot Selection" { screenshot show-pointer=false; }
      // Niri's screenshot chooser replaces the macOS screenshot toolbar.
      Mod+Shift+5 repeat=false hotkey-overlay-title="Screenshot Chooser" { screenshot show-pointer=false; }
      // keyd uses function-key sentinels so these cannot collide with
      // Ctrl+Shift+number, which moves windows between workspaces.
      Mod+Shift+F3 repeat=false hotkey-overlay-title="Copy Screenshot Screen" { screenshot-screen write-to-disk=false show-pointer=false; }
      Mod+Shift+F4 repeat=false hotkey-overlay-title="Screenshot Selection (Ctrl+C to Copy)" { screenshot show-pointer=false; }

      // Existing terminal and Paneru-style bindings.
      Mod+Ctrl+Alt+Return hotkey-overlay-title="Kitty" { spawn "kitty"; }
      Mod+Ctrl+Alt+R hotkey-overlay-title="Screenshot" { spawn-sh "noctalia msg screenshot-region"; }
      Mod+Ctrl+Alt+H { focus-column-left; }
      Mod+Ctrl+Alt+Q { focus-column-left; }
      Mod+Ctrl+Alt+J { focus-window-down; }
      Mod+Ctrl+Alt+K { focus-window-up; }
      Mod+Ctrl+Alt+S { focus-window-down; }
      Mod+Ctrl+Alt+W { focus-window-up; }
      Mod+Ctrl+Alt+L { focus-column-right; }
      Mod+Ctrl+Alt+E { focus-column-right; }
      Mod+Ctrl+Alt+Left { move-column-left; }
      Mod+Ctrl+Alt+Right { move-column-right; }
      Mod+Ctrl+Alt+Up { move-window-up; }
      Mod+Ctrl+Alt+Down { move-window-down; }
      Mod+Ctrl+Alt+A { move-window-up; }
      Mod+Ctrl+Alt+D { move-window-down; }
      Mod+Ctrl+Alt+Shift+Up { move-column-to-monitor-up; }
      Mod+Ctrl+Alt+Shift+Down { move-column-to-monitor-down; }
      // Match the explicit Option shortcuts in Diamond's Paneru config.
      Alt+C { center-column; }
      Alt+F { maximize-column; }
      Alt+R { switch-preset-column-width; }
      Alt+BracketLeft { consume-or-expel-window-left; }
      Alt+BracketRight { consume-or-expel-window-right; }
      Mod+Ctrl+Alt+C { center-column; }
      Mod+Ctrl+Alt+F { maximize-column; }
      Mod+Ctrl+Alt+Shift+R { switch-preset-column-width; }
      Mod+Ctrl+Alt+Equal { set-column-width "+10%"; }
      Mod+Ctrl+Alt+Minus { set-column-width "-10%"; }
      Mod+Ctrl+Alt+BracketLeft { consume-or-expel-window-left; }
      Mod+Ctrl+Alt+BracketRight { consume-or-expel-window-right; }
      Mod+Ctrl+Alt+Escape { toggle-window-floating; }

      Mod+Ctrl+Alt+Home { focus-column-first; }
      Mod+Ctrl+Alt+End { focus-column-last; }
      Mod+Ctrl+Alt+Shift+Home { move-column-to-first; }
      Mod+Ctrl+Alt+Shift+End { move-column-to-last; }
      Mod+Ctrl+Alt+Shift+H { focus-monitor-left; }
      Mod+Ctrl+Alt+Shift+J { focus-monitor-down; }
      Mod+Ctrl+Alt+Shift+K { focus-monitor-up; }
      Mod+Ctrl+Alt+Shift+L { focus-monitor-right; }

      // Physical Ctrl+arrows are distinct from the Ctrl+arrows generated for
      // Option+arrows in text fields. Niri arranges spaces vertically.
      Ctrl+Mod+Left { focus-workspace-up; }
      Ctrl+Mod+Right { focus-workspace-down; }
      Ctrl+Mod+Shift+Left { move-window-to-workspace-up; }
      Ctrl+Mod+Shift+Right { move-window-to-workspace-down; }
      Ctrl+Mod+Up repeat=false hotkey-overlay-title="Mission Control" { toggle-overview; }

      // Physical Ctrl+1..9 arrives from keyd as Ctrl+Mod+1..9.
      // Cmd+1..9 remains available to applications for selecting tabs.
      Ctrl+Mod+1 { focus-workspace 1; }
      Ctrl+Mod+2 { focus-workspace 2; }
      Ctrl+Mod+3 { focus-workspace 3; }
      Ctrl+Mod+4 { focus-workspace 4; }
      Ctrl+Mod+5 { focus-workspace 5; }
      Ctrl+Mod+6 { focus-workspace 6; }
      Ctrl+Mod+7 { focus-workspace 7; }
      Ctrl+Mod+8 { focus-workspace 8; }
      Ctrl+Mod+9 { focus-workspace 9; }

      Ctrl+Mod+Shift+1 { move-window-to-workspace 1; }
      Ctrl+Mod+Shift+2 { move-window-to-workspace 2; }
      Ctrl+Mod+Shift+3 { move-window-to-workspace 3; }
      Ctrl+Mod+Shift+4 { move-window-to-workspace 4; }
      Ctrl+Mod+Shift+5 { move-window-to-workspace 5; }
      Ctrl+Mod+Shift+6 { move-window-to-workspace 6; }
      Ctrl+Mod+Shift+7 { move-window-to-workspace 7; }
      Ctrl+Mod+Shift+8 { move-window-to-workspace 8; }
      Ctrl+Mod+Shift+9 { move-window-to-workspace 9; }

      // Hyper+1..9 focus the matching column on the current workspace.
      Mod+Ctrl+Alt+1 { focus-column 1; }
      Mod+Ctrl+Alt+2 { focus-column 2; }
      Mod+Ctrl+Alt+3 { focus-column 3; }
      Mod+Ctrl+Alt+4 { focus-column 4; }
      Mod+Ctrl+Alt+5 { focus-column 5; }
      Mod+Ctrl+Alt+6 { focus-column 6; }
      Mod+Ctrl+Alt+7 { focus-column 7; }
      Mod+Ctrl+Alt+8 { focus-column 8; }
      Mod+Ctrl+Alt+9 { focus-column 9; }

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
