-- Personal input overrides, loaded after Omarchy's defaults.

hl.config({
  input = {
    kb_layout = "us,ru",
    kb_options = "grp:alts_toggle",
  },
})

-- Repeat timing, numlock, touchpad behavior, and terminal-specific scroll
-- factors remain provided by Omarchy because they already match the legacy
-- user configuration.

-- Apple Magic Trackpad: behave like macOS defaults. Over USB it shows up as
-- two pointer devices, so configure both.
for _, name in ipairs({ "apple-inc.-magic-trackpad", "apple-inc.-magic-trackpad-1" }) do
  hl.device({
    name = name,
    tap_to_click = false, -- only a physical press clicks
    clickfinger_behavior = true, -- two-finger press = right click
    natural_scroll = true,
    scroll_factor = 0.15,
    sensitivity = 0.4,
  })
end

-- Apps that scroll slower than the browser at the trackpad's scroll factor.
-- scroll_touchpad replaces the scroll factor for that window.
o.window("org.telegram.desktop", { scroll_touchpad = 0.4 })

-- Make workspace swipes commit like macOS: a short flick or a small drag is
-- enough, instead of having to drag past the halfway point.
hl.config({
  gestures = {
    workspace_swipe_cancel_ratio = 0.15,
    workspace_swipe_min_speed_to_force = 5,
  },
})

-- Trackpad gestures. Two fingers stay reserved for scrolling.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "special", workspace_name = "scratchpad" })
hl.gesture({ fingers = 3, direction = "down", action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "pinchin", action = "close" })
hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })
