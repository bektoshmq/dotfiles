-- Personal keybinding overrides, loaded after Omarchy's defaults.

-- Navigate windows with Vim keys.
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))

hl.unbind("SUPER + J") -- Was: Toggle window split.
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

hl.unbind("SUPER + K") -- Was: Keybindings.
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))

hl.unbind("SUPER + L") -- Was: Toggle workspace layout.
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))

-- Move windows with Shift plus the same Vim keys.
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))

-- Drop the Google Maps webapp shortcut.
hl.unbind("SUPER + SHIFT + S") -- Was: Google Maps.

-- Keep Super+Space unused and move the menus to Alt+Space.
hl.unbind("SUPER + SPACE") -- Was: Omarchy menu.
o.bind("ALT + SPACE", "Apps menu", "omarchy-menu toggle apps")
o.bind("ALT + SHIFT + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Advantage360 Fn layer: this XKB map exposes its F13/F14 HID events under
-- the standard evdev multimedia symbols below.
o.bind("XF86Tools", "Brightness up (Advantage360)", "omarchy brightness display +5%", { locked = true, repeating = true })
o.bind("XF86Launch5", "Brightness down (Advantage360)", "omarchy brightness display 5%-", { locked = true, repeating = true })

-- Too easy to hit by accident; it rescales the monitor and rewrites monitors.lua.
hl.unbind("SUPER + SLASH") -- Was: Monitor scaling up.
