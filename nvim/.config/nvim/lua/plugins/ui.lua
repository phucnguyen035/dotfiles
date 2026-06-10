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
      navic.cond = function()
        return vim.bo.buftype ~= "terminal"
      end

      -- add it to the winbar instead
      opts.winbar = {
        lualine_b = {
          {
            "filename",
            path = 1,
            file_status = false,
            cond = function()
              return vim.bo.buftype ~= "terminal"
            end,
          },
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

      -- show attached LSP client count on the right side
      local lsp_count = {
        function()
          return tostring(#vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }))
        end,
        icon = "󱘖",
        cond = function()
          return #vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }) > 0
        end,
      }
      table.insert(opts.sections.lualine_x, 1, lsp_count)

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
        enabled = false,
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            layout = {
              layout = {
                position = "right",
              },
            },
          },
        },
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
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      max_lines = 3,
    },
  },
}
