-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.relativenumber = true
vim.g.autoformat = false
vim.opt.guicursor = ""

if vim.g.neovide then
  vim.opt.guifont = "JetBrainsMono Nerd Font:h18"
  vim.g.neovide_title_background_color = "black"
  vim.g.neovide_floating_blur_amount_x = 7.0
  vim.g.neovide_floating_blur_amount_y = 7.0
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_scroll_animation_far_lines = 5
end

if vim.fn.has("win32") == 1 then
  if vim.fn.exepath("nu") ~= "" then
    vim.opt.shell = "nu"
  end
end

vim.filetype.add({
  extension = {
    h = "c", -- Force .h files to be treated as C, not cpp
  },
})
