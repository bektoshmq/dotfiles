return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local theme = require("lualine.themes.auto")
    -- TODO: Replace this with a cleaner theme-aware override.
    -- lualine's "auto" theme derives section colors from current highlights,
    -- so after forcing rose-pine backgrounds to pure black, sections b/c no
    -- longer match the editor canvas and need this targeted adjustment.
    for mode_name, mode in pairs(theme) do
      if type(mode) == "table" then
        if type(mode.b) == "table" then
          mode.b.bg = "#000000"
        end
        if type(mode.c) == "table" then
          mode.c.bg = "#000000"
        end
        if mode_name == "inactive" and type(mode.a) == "table" then
          mode.a.bg = "#000000"
        end
      end
    end

    opts.options = opts.options or {}
    opts.options.theme = theme
    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = { left = "", right = "" }

    opts.sections.lualine_b = {}
    opts.sections.lualine_y = {}
    opts.sections.lualine_z = {}
    return opts
  end,
}
