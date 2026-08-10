{
  paneru,
  externalPackage,
  ...
}: {
  imports = [paneru.homeModules.paneru];

  # paneru: sliding/tiling window manager for macOS.
  # Bindings translated 1:1 from the old Hammerspoon + PaperWM setup that lived
  # in home/programs/gui/hammerspoon/init.lua (see git history).
  services.paneru = {
    enable = true;
    package = externalPackage "paneru" {};

    settings = {
      # Screen-edge padding (the outer frame around the whole tiling area).
      padding = {
        top = 6;
        bottom = 6;
        left = 6;
        right = 6;
      };

      # Gaps *between* windows. paneru has no global window-gap option; the gap
      # between two adjacent windows is the sum of their per-window paddings, so
      # this catch-all rule (title ".*" matches everything) gives every window
      # 5px on each side => a 10px gap between neighbours. The outermost windows
      # also get this 5px on top of the screen-edge `padding` above.
      windows.all = {
        title = ".*";
        horizontal_padding = 6;
        vertical_padding = 6;
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
        animation_speed = 40.0;

        reap_empty_workspaces = true;

        virtual_workspace_animations = true;
      };

      # Replaces Swipe.spoon: a 3-finger swipe scrolls the window strip / moves
      # focus. Old code used "natural" scrolling and wm.swipe_gain = 2.0.
      swipe = {
        sensitivity = 0.5;
        discrete = true;
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

        # --- focus the Nth column (ctrl+alt+cmd + 1..9) ----------------------
        # PaperWM's focus_window_N. Upstream paneru has no focus-by-index
        # command, so `window_focusnum_N` comes from the local patch pinned as
        # the `paneru` flake input (see flake.nix). Counted horizontally from the
        # left of the strip; stacked columns focus their top window.
        # window_focusnum_1 = "alt + cmd + ctrl - 1";
        # window_focusnum_2 = "alt + cmd + ctrl - 2";
        # window_focusnum_3 = "alt + cmd + ctrl - 3";
        # window_focusnum_4 = "alt + cmd + ctrl - 4";
        # window_focusnum_5 = "alt + cmd + ctrl - 5";
        # window_focusnum_6 = "alt + cmd + ctrl - 6";
        # window_focusnum_7 = "alt + cmd + ctrl - 7";
        # window_focusnum_8 = "alt + cmd + ctrl - 8";
        # window_focusnum_9 = "alt + cmd + ctrl - 9";

        # --- switch to virtual workspace N (ctrl + 1..9) ---------------------
        window_virtualnum_1 = "ctrl - 1";
        window_virtualnum_2 = "ctrl - 2";
        window_virtualnum_3 = "ctrl - 3";
        window_virtualnum_4 = "ctrl - 4";
        window_virtualnum_5 = "ctrl - 5";
        window_virtualnum_6 = "ctrl - 6";
        window_virtualnum_7 = "ctrl - 7";
        window_virtualnum_8 = "ctrl - 8";
        window_virtualnum_9 = "ctrl - 9";

        # --- send focused window to virtual workspace N (add shift) ----------
        # "send" = the window moves to workspace N but focus stays on the current
        # workspace. Swap these for window_virtualmovenum_N if you'd rather
        # follow the window to its new workspace.
        window_virtualmovenum_1 = "ctrl + shift - 1";
        window_virtualmovenum_2 = "ctrl + shift - 2";
        window_virtualmovenum_3 = "ctrl + shift - 3";
        window_virtualmovenum_4 = "ctrl + shift - 4";
        window_virtualmovenum_5 = "ctrl + shift - 5";
        window_virtualmovenum_6 = "ctrl + shift - 6";
        window_virtualmovenum_7 = "ctrl + shift - 7";
        window_virtualmovenum_8 = "ctrl + shift - 8";
        window_virtualmovenum_9 = "ctrl + shift - 9";

        # --- service ---------------------------------------------------------
        # Restarts the paneru background service (same as `paneru restart`).
        restart = "ctrl + shift - r";
      };
    };
  };
}
