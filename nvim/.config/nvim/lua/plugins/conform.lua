return {
  "stevearc/conform.nvim",
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      javascript = { "prettier", "biome", "biome-organize-imports" },
      javascriptreact = { "prettier", "biome", "biome-organize-imports" },
      typescript = { "prettier", "biome", "biome-organize-imports" },
      typescriptreact = { "prettier", "biome", "biome-organize-imports" },
    },
    formatters = {
      ["biome-organize-imports"] = {
        require_cwd = true,
      },
    },
  },
}
