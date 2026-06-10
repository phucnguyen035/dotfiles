return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'nvim-lspconfig'
    opts = {
      setup = {},
      servers = {
        ["*"] = {
          keys = {
            { "<C-k>", false, mode = "i" },
          },
        },
      },
    },
  },
}
