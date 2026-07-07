---@param opts conform.setupOpts
local setup_ts_formatter = function(opts)
  local support = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
  }

  opts.formatters_by_ft = opts.formatters_by_ft or {}

  for _, ft in ipairs(support) do
    opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
    ---@diagnostic disable-next-line: param-type-mismatch
    table.insert(opts.formatters_by_ft[ft], "biome-check")
  end

  opts.formatters = opts.formatters or {}
  opts.formatters["biome-check"] = {
    require_cwd = true,
  }
end

---@param opts conform.setupOpts
local setup_python_formatter = function(opts)
  opts.formatters_by_ft = opts.formatters_by_ft or {}

  opts.formatters_by_ft.python = {
    "ruff_fix",
    "ruff_format",
    "ruff_organize_imports",
  }
end

return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    setup_ts_formatter(opts)
    setup_python_formatter(opts)
  end,
}
