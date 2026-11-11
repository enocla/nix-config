{lib, ...}: let
  digits = map toString (lib.range 0 9);
  hyperKeys =
    lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz"
    ++ digits
    ++ ["comma" "semicolon" "slash" "backslash" "leftbrace" "rightbrace" "equal" "minus" "enter" "esc" "space" "tab" "grave" "dot" "left" "right" "up" "down" "home" "end" "pageup" "pagedown" "backspace" "delete"];
  withModifiers = modifiers: keys: lib.genAttrs keys (key: "${modifiers}-${key}");
in {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        global.overload_tap_timeout = 250;
        main = {
          capslock = "overload(hyper, tab)";
          # Bottom row reports Ctrl | Meta | Alt. Swap Ctrl and Super so the
          # physical Command key (Alt keycode) is Ctrl for applications and
          # the physical Control key is Super for the compositor. Option
          # (Meta keycode) stays Alt.
          leftalt = "layer(control)";
          leftmeta = "layer(alt)";
          leftcontrol = "layer(meta)";
          rightalt = "layer(control)";
          rightmeta = "layer(alt)";
          rightcontrol = "layer(meta)";

          "leftshift+rightshift" = "capslock";

          # fn arrives as bare F7-F12; shift+fn arrives as bare media keys.
          # (The firmware eats Shift for consumer-page outputs.) Swap them
          # so plain fn gives media and shift+fn gives F-keys. F1-F6 are
          # untouched: shift+fn+1..5 arrives as Shift+F1..F5, and keyd
          # cannot strip a physically held Shift.
          f7 = "previoussong";
          f8 = "playpause";
          f9 = "nextsong";
          f10 = "mute";
          f11 = "volumedown";
          f12 = "volumeup";

          previoussong = "f7";
          playpause = "f8";
          nextsong = "f9";
          mute = "f10";
          volumedown = "f11";
          volumeup = "f12";
        };
        shift = {
          esc = "S-`";
        };
        # Physical Ctrl (Super): Ctrl+Tab cycles application tabs.
        meta = {
          tab = "C-tab";
        };
        # Physical Option: word jumps and word deletion.
        alt = {
          left = "C-left";
          right = "C-right";
          backspace = "C-backspace";
        };
        # Physical Cmd: line and document jumps, delete to line start.
        control = {
          left = "home";
          right = "end";
          up = "C-home";
          down = "C-end";
          # kitty maps Shift+Home to Ctrl+U; Backspace is then a no-op at the
          # start of the line.
          backspace = "macro(S-home backspace)";
          # Niri's window switcher. Plain F17/F18 keep Ctrl (the layer's own
          # modifier) held between taps, so Cmd can be held to keep cycling.
          tab = "C-f17";
          grave = "C-f18";
        };
        "hyper:C-M-A" = {};
      };
      # Composite layers must follow their constituent layers.
      extraConfig = lib.generators.toINI {} {
        "hyper+shift" = withModifiers "C-M-A-S" hyperKeys;
        "meta+shift".tab = "C-S-tab";
        # Shift extends the selection.
        "alt+shift" = {
          left = "C-S-left";
          right = "C-S-right";
        };
        "control+shift" = {
          left = "S-home";
          right = "S-end";
          up = "C-S-home";
          down = "C-S-end";
          tab = "C-S-f17";
          grave = "C-S-f18";
        };
        # Keep Cmd+Option+arrows as a plain chord (kitty tab navigation).
        "control+alt" = {
          left = "C-A-left";
          right = "C-A-right";
          up = "C-A-up";
          down = "C-A-down";
        };
      };
    };
  };

  # keyd 2.6 drops to the keyd group at startup. The upstream NixOS unit only
  # keeps CAP_SYS_NICE, so setgid fails unless CAP_SETGID is added explicitly.
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = lib.mkAfter ["CAP_SETGID"];

  users.groups.keyd = {};
}
