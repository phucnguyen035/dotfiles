return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        vtsls = function(_, opts)
          opts.settings.javascript = {
            tsserver = { maxTsServerMemory = 16184 },
          }

          opts.settings.typescript.tsserver = { maxTsServerMemory = 16184 }
          opts.settings.typescript.inlayHints.parameterTypes.enabled = false
          opts.settings.typescript.inlayHints.functionLikeReturnTypes.enabled = false
        end,
        eslint = function(_, opts)
          opts.settings.codeActionOnSave = {
            enable = true,
          }
        end,
      },
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
