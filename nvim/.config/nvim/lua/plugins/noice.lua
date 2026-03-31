return {
  "folke/noice.nvim",
  ---@module 'noice'
  ---@type NoiceConfig
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = {
          skip = true,
        },
      },
    },
  },
}
