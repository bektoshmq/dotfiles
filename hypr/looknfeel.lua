-- Personal appearance overrides, loaded after Omarchy's defaults.

hl.config({
  general = {
    -- Stop directional focus at window edges instead of wrapping around.
    no_focus_fallback = true,
  },

  decoration = {
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,

    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      brightness = 0.85,
      contrast = 0.90,
      noise = 0.02,
      special = false,
      popups = false,
    },
  },
})

-- Override Omarchy's per-app and default opacity rules with exact values.
o.window(".*", { opacity = "1.0 override 1.0 override 1.0 override" })

-- Match Ghostty's 0.82 transparency while using the global backdrop blur.
o.window("^md\\.obsidian\\.Obsidian$", { opacity = "0.82 override 0.82 override 0.82 override" })
o.window("^cursor$", { opacity = "0.82 override 0.82 override 0.82 override" })
o.window("^chatgpt$", { opacity = "0.82 override 0.82 override 0.82 override" })
