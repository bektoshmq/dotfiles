-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.guicursor = ""
vim.filetype.add({
  extension = {
    h = "c", -- Force .h files to be treated as C, not cpp
  },
})
