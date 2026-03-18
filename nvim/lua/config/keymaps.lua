-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function toggle_root_terminal()
  local terminal = vim.b.snacks_terminal
  local cwd = (vim.bo.filetype == "snacks_terminal" and terminal and terminal.cwd) or LazyVim.root()
  Snacks.terminal(nil, { cwd = cwd })
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_root_terminal, { desc = "Terminal (Root Dir)" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_root_terminal, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>ft", toggle_root_terminal, { desc = "Terminal (Root Dir)" })
