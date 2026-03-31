return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options.disabled_filetypes.winbar = {
      "snacks_dashboard",
      "lazy",
      "alpha",
      "sidekick_terminal",
    }

    local navic = table.remove(opts.sections.lualine_c)

    -- add it to the winbar instead
    opts.winbar = {
      lualine_b = {
        { "filename", path = 1, file_status = false },
      },
      lualine_c = { navic },
    }

    opts.sections.lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    }

    local diff = table.remove(opts.sections.lualine_x)

    opts.sections.lualine_c = {
      diff,
    }

    return opts
  end,
}
