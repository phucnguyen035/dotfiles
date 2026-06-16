return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'nvim-lspconfig'
    opts = {
      setup = {},
      servers = {
        tsgo = {
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = {
                  enabled = false,
                },
                functionLikeReturnTypes = {
                  enabled = false,
                },
                parameterNames = {
                  enabled = "literals",
                  suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = {
                  enabled = false,
                },
                propertyDeclarationTypes = {
                  enabled = true,
                },
                variableTypes = {
                  enabled = false,
                },
              },
            },
          },
        },
        ["*"] = {
          keys = {
            { "<C-k>", false, mode = "i" },
          },
        },
      },
    },
  },
}
