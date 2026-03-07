local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.default_prog = {
  'nu.exe',
  '--config',
  [[D:\dotfiles\nushell\.config\nushell\config.nu]],
  '--env-config',
  [[D:\dotfiles\nushell\.config\nushell\env.nu]],
}
config.default_cwd = [[D:\]]

config.window_decorations = 'RESIZE'
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.window_close_confirmation = 'NeverPrompt'
config.automatically_reload_config = true

config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Medium' })
config.font_size = 18
config.font_rules = {
  {
    intensity = 'Bold',
    italic = false,
    font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold' }),
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font('JetBrainsMono Nerd Font', {
      weight = 'Bold',
      style = 'Italic',
    }),
  },
  {
    intensity = 'Normal',
    italic = true,
    font = wezterm.font('JetBrainsMono Nerd Font', {
      weight = 'Medium',
      style = 'Italic',
    }),
  },
}

config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.animation_fps = 1
config.hide_mouse_cursor_when_typing = true

config.color_scheme = 'rose-pine'
config.colors = {
  background = '#000000',
}

config.window_background_opacity = 1.0

config.keys = {
  {
    key = 'P',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivateCommandPalette,
  },
}

return config



