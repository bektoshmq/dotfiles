-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

--- C/C++ indentation settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true -- Use spaces
    vim.opt_local.cindent = true -- Use cindent instead of treesitter indent
    vim.opt_local.indentexpr = "" -- Disable treesitter/LSP indentexpr
    vim.opt_local.cinoptions = ":0,l1,g0" -- case labels: no extra indent, code after case indented by shiftwidth
  end,
})
