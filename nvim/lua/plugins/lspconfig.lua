return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              library = {
                vim.fn.expand("~/.local/share/prise/lua"),
              },
            },
          },
        },
      },
      clangd = {
        cmd = {
          "clangd",
          "--header-insertion=never",
        },
      },
    },
  },
}
