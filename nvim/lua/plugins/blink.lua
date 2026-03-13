return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  opts = {
    keymap = {
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },
    cmdline = {
      keymap = {
        preset = "inherit",
      },
    },
  },
}
