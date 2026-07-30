return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
  {
    "paulbkim-dev/vim-herdr-navigation",
    dependencies = { "christoomey/vim-tmux-navigator" },
    lazy = false,
    config = function(plugin)
      dofile(plugin.dir .. "/editor/nvim.lua")
    end,
  },
}
