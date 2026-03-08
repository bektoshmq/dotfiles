return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      on_colors = function(c)
        c.bg_statusline = "#000000"
      end,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        keywords = { italic = false },
      },
      on_highlights = function(hl, c)
        hl.FloatBorder = {
          fg = c.green,
          bg = "NONE",
        }
        hl.WhichKeyBorder = hl.FloatBorder
        hl.FzfLuaBorder = hl.FloatBorder
        hl.FzfLuaPreviewBorder = hl.FloatBorder

        hl["@string.go"] = { fg = c.violet500 }

        hl.CursorLine = { bg = "#000000" }
      end,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "main",
      styles = {
        italic = false,
        transparency = true,
        bold = true,
      },
      highlight_groups = {
        CursorLine = { bg = "#000000" },
        ["@field"] = { fg = "text" },
        ["@property"] = { fg = "text" },
        ["@lsp.type.property"] = { fg = "text" },
        ["@variable.member"] = { fg = "text" },
        ["@type.builtin"] = { bold = false },
        ["@function.builtin"] = { bold = false },
      },
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    name = "cyberdream",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "dark",
      transparent = true,
      hide_fillchars = true,
      overrides = function(colors)
        return {
          CursorLine = { bg = "#000000" },
          ["@keyword"] = { fg = colors.orange, italic = false },
          ["@keyword.type"] = { fg = colors.orange, italic = false },
          ["@type"] = { fg = colors.purple, italic = false },
          ["@type.builtin"] = { fg = colors.purple, italic = false },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
