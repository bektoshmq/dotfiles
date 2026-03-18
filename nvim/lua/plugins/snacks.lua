return {
  "folke/snacks.nvim",
  opts = {
    indent = { enabled = false },
    words = { enabled = false },
    scroll = { enabled = false },
    image = { enabled = true },
    picker = {
      layout = {
        preset = function()
          if vim.g.neovide then
            return "ivy_split"
          end
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
      },
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true, -- show hidden files by default
          layout = {
            layout = {
              position = "right",
              width = 0.5,
              min_width = 30,
            },
          },
        },
      },
    },
  },
}
