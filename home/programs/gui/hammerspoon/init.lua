require("hs.ipc")

wm = hs.loadSpoon("PaperWM")
wm.window_ratios = { 1 / 3, 1 / 2, 2 / 3, 4 / 5 }
wm.swipe_fingers = 0
wm.swipe_gain = 2.0

wm:bindHotkeys({
    -- switch to a new focused window in tiled grid
    focus_left = { { "alt", "cmd", "ctrl" }, "h" },
    focus_down = { { "alt", "cmd", "ctrl" }, "j" },
    focus_up = { { "alt", "cmd", "ctrl" }, "k" },
    focus_right = { { "alt", "cmd", "ctrl" }, "l" },
    -- move windows around in tiled grid
    swap_left = { { "alt", "cmd", "ctrl" }, "left" },
    swap_right = { { "alt", "cmd", "ctrl" }, "right" },
    swap_up = { { "alt", "cmd", "ctrl" }, "up" },
    swap_down = { { "alt", "cmd", "ctrl" }, "down" },

    -- position and resize focused window
    center_window = { { "alt" }, "c" },
    full_width = { { "alt" }, "f" },
    cycle_width = { { "alt" }, "r" },
    refresh_windows = { { "alt" }, "g" },

    -- increase/decrease width
    increase_width = { { "alt", "cmd", "ctrl" }, "=" },
    decrease_width = { { "alt", "cmd", "ctrl" }, "-" },

    -- move focused window into / out of a column
    slurp_in = { { "alt" }, "[" },
    barf_out = { { "alt" }, "]" },

    -- move the focused window into / out of the tiling layer
    toggle_floating = { { "alt", "cmd", "ctrl" }, "escape" },
    -- raise all floating windows on top of tiled windows
    focus_floating = { { "alt", "cmd", "shift" }, "f" },

    -- focus the first / second / etc window in the current space
    focus_window_1 = { { "ctrl", "cmd", "alt" }, "1" },
    focus_window_2 = { { "ctrl", "cmd", "alt" }, "2" },
    focus_window_3 = { { "ctrl", "cmd", "alt" }, "3" },
    focus_window_4 = { { "ctrl", "cmd", "alt" }, "4" },
    focus_window_5 = { { "ctrl", "cmd", "alt" }, "5" },
    focus_window_6 = { { "ctrl", "cmd", "alt" }, "6" },
    focus_window_7 = { { "ctrl", "cmd", "alt" }, "7" },
    focus_window_8 = { { "ctrl", "cmd", "alt" }, "8" },
    focus_window_9 = { { "ctrl", "cmd", "alt" }, "9" },
})

-- focus adjacent window with 3 finger swipe
local actions = wm.actions.actions()
local current_id, threshold
Swipe = hs.loadSpoon("Swipe")
Swipe:start(3, function(direction, distance, id)
    if id == current_id then
        if distance > threshold then
            threshold = math.huge -- trigger once per swipe

            -- use "natural" scrolling
            if direction == "left" then
                actions.focus_right()
            elseif direction == "right" then
                actions.focus_left()
            elseif direction == "up" then
                actions.focus_down()
            elseif direction == "down" then
                actions.focus_up()
            end
        end
    else
        current_id = id
        threshold = 0.05 -- swipe distance > 20% of trackpad size
    end
end)

-- Function to move focused window to adjacent monitor in specified direction
local function moveWindowToDirection(direction)
    local focused_window = hs.window.focusedWindow()
    if not focused_window then
        return
    end

    -- get list of screens allowed by the window filter as hs.screen objects
    local allowed_screens = wm.window_filter:getFilters().override.allowScreens or hs.screen.allScreens()
    allowed_screens = hs.fnutils.imap(allowed_screens, function(screen)
        return hs.screen.find(screen)
    end)

    local old_screen = focused_window:screen()
    if not old_screen then
        wm.logger.d("no screen for window")
        return
    end

    -- if window is on a managed space and is not floating, then toggling it to floating
    -- this will retile the current space before moving the window
    if hs.fnutils.contains(allowed_screens, old_screen) and not wm.floating.isFloating(focused_window) then
        wm.floating.toggleFloating(focused_window)
    end

    -- Check if screens are adjacent in the specified direction
    if direction == "left" then
        focused_window:moveOneScreenWest(true)
    elseif direction == "right" then
        focused_window:moveOneScreenEast(true)
    elseif direction == "up" then
        focused_window:moveOneScreenNorth(true)
    elseif direction == "down" then
        focused_window:moveOneScreenSouth(true)
    end

    local do_add_window = coroutine.wrap(function()
        repeat -- wait until window appears on new screen
            coroutine.yield(false) -- not done
        until focused_window:screen() ~= old_screen

        -- now we can toggle it not floating, add the window, and tile new space
        wm.floating.toggleFloating(focused_window)
        return true -- done
    end)

    local start_time = hs.timer.secondsSinceEpoch()
    hs.timer.doUntil(do_add_window, function(timer)
        if hs.timer.secondsSinceEpoch() - start_time > 1 then
            timer:stop()
        end
    end, hs.window.animationDuration)
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "a", function()
    moveWindowToDirection("up")
end)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "d", function()
    moveWindowToDirection("down")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "e", actions.focus_right)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "q", actions.focus_left)

hs.window.animationDuration = 0.1

wm:start()

