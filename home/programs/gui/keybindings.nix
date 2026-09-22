{
  lib,
  pkgs,
  ...
}: let
  digits = map toString (lib.range 1 9);
  letters = lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz";
  forwardKeys = layer: modifier: keys:
    lib.concatMapStringsSep "\n" (key: "${layer}.${key} = ${modifier}-${key}") keys;
  tabNumbers = forwardKeys "cmd" "A" digits;
  browserBindings = ''
    # Cocoa-style Control editing in browser text fields. Keep this scoped to
    # browsers: editors and terminals have their own intentional Ctrl bindings.
    control.a = home
    control.b = left
    control.d = delete
    control.e = end
    control.f = right
    control.h = backspace
    control.k = macro(S-end delete)
    control.n = down
    control.p = up
    control.v = pagedown
    # Chrome has no Linux quit accelerator. Use its documented English menu
    # action; Alt+E avoids the user's Paneru-style Alt+F compositor binding.
    cmd.q = macro(A-e 150ms x)
    # Open preferences in a fresh tab, preserving the current page.
    cmd.comma = macro(C-t 150ms chrome://settings enter)
    # History navigation keeps Cmd+arrows available for editing text fields.
    cmd.[ = A-left
    cmd.] = A-right
    cmd.y = C-h
    cmd+shift.j = C-j
    cmd+shift.h = A-home
    cmd+shift.m = C-S-m
    cmd+shift.backspace = C-S-delete
    cmd+alt.b = C-S-o
    cmd+alt.c = C-S-c
    cmd+alt.f = C-k
    cmd+alt.i = C-S-i
    cmd+alt.j = C-S-j
    cmd+alt.u = C-u
    cmd+alt.up = f6
    cmd+alt.down = f6
    cmd+alt+shift.i = A-S-i
    cmd+alt+shift.a = A-S-a
  '';
in {
  # Application exceptions to the system's macOS shortcut translation. keyd
  # normalizes app IDs to lowercase with punctuation replaced by hyphens.
  xdg.configFile."keyd/app.conf".text = ''
    [kitty]
    # A terminal must not receive Ctrl+D/Z/S for ordinary Cmd shortcuts.
    # Kitty handles Super itself while the physical Ctrl key keeps shell jobs
    # and terminal applications working normally, including Ctrl+C (SIGINT).
    ${forwardKeys "cmd" "M" (letters ++ ["0"] ++ digits ++ ["equal" "minus" "comma" "enter" "home" "end" "pageup" "pagedown" "up" "down"])}
    ${forwardKeys "cmd+shift" "M-S" letters}
    cmd+shift.equal = M-S-equal
    cmd+shift.minus = M-S-minus
    cmd+shift.[ = M-S-[
    cmd+shift.] = M-S-]
    cmd+alt.left = M-A-left
    cmd+alt.right = M-A-right
    cmd+alt.k = M-A-k
    cmd+alt.r = M-A-r
    cmd+alt.comma = M-A-comma
    cmd+control.l = M-C-l
    cmd+control.comma = M-C-comma
    # Shell editing uses the terminal's existing line/word editing commands.
    cmd.backspace = C-u
    cmd.delete = C-k
    alt.backspace = A-backspace

    [dev-zed-zed*]
    ${tabNumbers}
    # The shared Zed keymap already defines these native Cmd shortcuts.
    cmd./ = M-/
    cmd+shift.k = M-S-k
    # Ctrl+G is Go To Line on Linux; macOS Cmd+G finds the next match.
    cmd.g = f3
    cmd+shift.g = S-f3

    [google-chrome*]
    ${browserBindings}

    [chromium*]
    ${browserBindings}

    [org-gnome-nautilus*]
    ${tabNumbers}
    cmd.[ = A-left
    cmd.] = A-right
    cmd.up = A-up
    cmd.down = A-down
    cmd.o = A-down
    cmd.i = A-enter
    cmd.backspace = delete
    # Finder's Empty Trash chord must not become Shift+Delete on the selected
    # files. Nautilus does not expose an equivalent keyboard action.
    cmd+shift.backspace = noop
    cmd+alt+shift.backspace = noop
    # Finder's explicit Delete Immediately shortcut keeps Nautilus's prompt.
    cmd+alt.backspace = S-delete
    cmd+shift.g = C-l
    cmd+shift.h = A-home
    cmd+shift.dot = C-h
    # Keep Return available to accept names and paths; F2 still renames.
    # Nautilus has no native Finder-style Cmd+D duplicate action.
    cmd.d = noop
  '';

  systemd.user.services.keyd-application-mapper = {
    Unit = {
      Description = "Keyd application-specific keyboard mappings";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Environment = ["PATH=${lib.makeBinPath [pkgs.keyd]}"];
      ExecStart = ["${pkgs.keyd}/bin/keyd-application-mapper"];
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
