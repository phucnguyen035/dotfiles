return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        vtsls = function(_, opts)
          opts.settings.typescript.inlayHints.parameterTypes.enabled = false
          opts.settings.typescript.inlayHints.functionLikeReturnTypes.enabled = false
        end,
      },
    },
  },
}
