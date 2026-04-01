---@module "lazy"
---@type LazySpec[]
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
  {
    "catppuccin/nvim",
    opts = {},
  },
  {
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
  },
  {
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
  },
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      scroll = {
        animate = {
          fps = 120,
        },
      },
      picker = {
        win = {
          input = {
            keys = {
              ["<a-i>"] = false,
              ["<a-I>"] = { "toggle_ignored", mode = { "i", "n" } },
              ["<a-h>"] = false,
              ["<a-H>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<m-p>"] = false,
              ["<a-/>"] = { "toggle_preview", mode = { "i", "n" } },
              ["<c-g>"] = false,
              ["<a-g>"] = { "toggle_live", mode = { "i", "n" } },
            },
          },
        },
      },
    },
  },
}
