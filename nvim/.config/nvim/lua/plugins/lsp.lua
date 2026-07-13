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
  {
    "r4ppz/lspeek.nvim",
    opts = {
      window = {
        border = "rounded",
      },
    },
    keys = {
      {
        "gD",
        function()
          require("lspeek").peek_definition()
        end,
        desc = "Peek Definition (lspeek)",
      },
      {
        "gT",
        function()
          require("lspeek").peek_type_definition()
        end,
        desc = "Peek Type Definition (lspeek)",
      },
    },
  },
}
