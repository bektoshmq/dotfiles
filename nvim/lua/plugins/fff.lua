local function cwd()
  return assert(vim.uv.cwd())
end

local function root()
  return LazyVim.root()
end

local function find_files(path)
  require("fff").find_files_in_dir(path)
end

local function live_grep(path)
  require("fff").live_grep({ cwd = path })
end

local function grep_word(path)
  require("fff").live_grep_under_cursor({ cwd = path })
end

return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      keymaps = {
        move_up = { "<Up>", "<C-p>", "<C-k>" },
        move_down = { "<Down>", "<C-n>", "<C-j>" },
      },
    },
    keys = {
      { "<leader><space>", function() find_files(root()) end, desc = "Find Files (Root Dir)" },
      { "<leader>ff", function() find_files(root()) end, desc = "Find Files (Root Dir)" },
      { "<leader>fF", function() find_files(cwd()) end, desc = "Find Files (cwd)" },
      { "<leader>/", function() live_grep(root()) end, desc = "Grep (Root Dir)" },
      { "<leader>sg", function() live_grep(root()) end, desc = "Grep (Root Dir)" },
      { "<leader>sG", function() live_grep(cwd()) end, desc = "Grep (cwd)" },
      {
        "<leader>sw",
        function() grep_word(root()) end,
        mode = { "n", "x" },
        desc = "Visual selection or word (Root Dir)",
      },
      {
        "<leader>sW",
        function() grep_word(cwd()) end,
        mode = { "n", "x" },
        desc = "Visual selection or word (cwd)",
      },
    },
  },
}
