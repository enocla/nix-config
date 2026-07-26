{paneru, ...}: {
  imports = [paneru.homeModules.paneru];

  # paneru: sliding/tiling window manager for macOS.
  # Bindings translated 1:1 from the old Hammerspoon + PaperWM setup that lived
  # in home/programs/gui/hammerspoon/init.lua (see git history).
  services.paneru = {
    enable = true;

    settings = {
      # Screen-edge padding (the outer frame around the whole tiling area).
      padding = {
        top = 10;
        bottom = 10;
        left = 10;
        right = 10;
      };

      # Gaps *between* windows. paneru has no global window-gap option; the gap
      # between two adjacent windows is the sum of their per-window paddings, so
      # this catch-all rule (title ".*" matches everything) gives every window
      # 5px on each side => a 10px gap between neighbours. The outermost windows
      # also get this 5px on top of the screen-edge `padding` above.
      windows.all = {
        title = ".*";
        horizontal_padding = 5;
        vertical_padding = 5;
      };

      options = {
        # PaperWM was keyboard-driven; don't let focus chase the mouse.
        # Flip either of these to true if you'd rather have focus/mouse warp.
        focus_follows_mouse = true;
        mouse_follows_focus = false;

        # Old: wm.window_ratios = { 1/3, 1/2, 2/3, 4/5 }
        preset_column_widths = [0.333 0.5 0.667 0.8];

        # Old: hs.window.animationDuration = 0.1 (snappy). This is an animation
        # rate (higher = faster); tweak to taste.
        animation_speed = 30.0;
      };

      # Replaces Swipe.spoon: a 3-finger swipe scrolls the window strip / moves
      # focus. Old code used "natural" scrolling and wm.swipe_gain = 2.0.
      swipe = {
        sensitivity = 0.5;
        gesture = {
          fingers_count = 3;
          direction = "Natural";
          vertical = true;
        };
      };

      bindings = {
        # --- focus (h/j/k/l) -------------------------------------------------
        # q/e were duplicate focus-left/right binds in the old config, kept here
        # as extra keys (paneru allows an array of keys per command).
        window_focus_west = ["alt + cmd + ctrl - h" "alt + cmd + ctrl - q"];
        window_focus_south = "alt + cmd + ctrl - j";
        window_focus_north = "alt + cmd + ctrl - k";
        window_focus_east = ["alt + cmd + ctrl - l" "alt + cmd + ctrl - e"];

        # --- swap / move (arrows) -------------------------------------------
        window_swap_west = "alt + cmd + ctrl - leftarrow";
        window_swap_east = "alt + cmd + ctrl - rightarrow";
        # 'a'/'d' moved the window to the monitor above/below in the old config.
        # paneru folds that into swap_north/south: swap within the column, or
        # move to the display in that direction at the strip edge.
        window_swap_north = ["alt + cmd + ctrl - uparrow" "alt + cmd + ctrl - a"];
        window_swap_south = ["alt + cmd + ctrl - downarrow" "alt + cmd + ctrl - d"];

        # --- position & resize ----------------------------------------------
        window_center = "alt - c"; # center_window
        window_fullwidth = "alt - f"; # full_width
        window_resize = "alt - r"; # cycle_width (cycle preset widths)
        window_grow = "alt + cmd + ctrl - equal"; # increase_width
        window_shrink = "alt + cmd + ctrl - minus"; # decrease_width
        # refresh_windows (alt - g) has no paneru equivalent — paneru retiles
        # automatically — so it is intentionally left unbound.

        # --- columns / stacking ---------------------------------------------
        window_stack = "alt - leftbracket"; # slurp_in
        window_unstack = "alt - rightbracket"; # barf_out

        # --- floating --------------------------------------------------------
        window_manage = "alt + cmd + ctrl - escape"; # toggle_floating
        window_raise_floating = "alt + cmd + shift - f"; # focus_floating

        # --- numbered targets (ctrl+cmd+alt + 1..9) -------------------------
        # PaperWM's focus_window_N focused the Nth window in the space. paneru
        # has no such command, so these switch to virtual workspace N — the
        # closest numbered-target analogue.
        # window_virtualnum_1 = "ctrl + cmd + alt - 1";
        # window_virtualnum_2 = "ctrl + cmd + alt - 2";
        # window_virtualnum_3 = "ctrl + cmd + alt - 3";
        # window_virtualnum_4 = "ctrl + cmd + alt - 4";
        # window_virtualnum_5 = "ctrl + cmd + alt - 5";
        # window_virtualnum_6 = "ctrl + cmd + alt - 6";
        # window_virtualnum_7 = "ctrl + cmd + alt - 7";
        # window_virtualnum_8 = "ctrl + cmd + alt - 8";
        # window_virtualnum_9 = "ctrl + cmd + alt - 9";

        # --- send focused window to virtual workspace N (add shift) ----------
        # "send" = the window moves to workspace N but focus stays on the current
        # workspace. Swap these for window_virtualmovenum_N if you'd rather
        # follow the window to its new workspace.
        # window_virtualsendnum_1 = "ctrl + cmd + alt + shift - 1";
        # window_virtualsendnum_2 = "ctrl + cmd + alt + shift - 2";
        # window_virtualsendnum_3 = "ctrl + cmd + alt + shift - 3";
        # window_virtualsendnum_4 = "ctrl + cmd + alt + shift - 4";
        # window_virtualsendnum_5 = "ctrl + cmd + alt + shift - 5";
        # window_virtualsendnum_6 = "ctrl + cmd + alt + shift - 6";
        # window_virtualsendnum_7 = "ctrl + cmd + alt + shift - 7";
        # window_virtualsendnum_8 = "ctrl + cmd + alt + shift - 8";
        # window_virtualsendnum_9 = "ctrl + cmd + alt + shift - 9";
      };
    };
  };
}
