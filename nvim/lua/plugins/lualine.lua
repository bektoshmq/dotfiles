return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options = opts.options or {}
    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = { left = "", right = "" }

    opts.sections.lualine_b = {}
    opts.sections.lualine_y = {}
    opts.sections.lualine_z = {}
    return opts
  end,
}
