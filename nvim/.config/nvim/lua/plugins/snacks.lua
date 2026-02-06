return {
  "folke/snacks.nvim",
  opts = {
    indent = { enabled = false },
    words = { enabled = false },
    scroll = { enabled = false },
    picker = {
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
