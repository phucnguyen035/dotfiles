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
    "akinsho/bufferline.nvim",
    enabled = false,
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

      -- distinct highlight for the harpoon line: active item bold + accent, others dim
      local function set_harpoon_hl()
        local ok, palette = pcall(require, "catppuccin.palettes")
        local c = ok and palette.get_palette() or {}
        vim.api.nvim_set_hl(0, "LualineHarpoonActive", { fg = c.peach, bold = true })
        vim.api.nvim_set_hl(0, "LualineHarpoonInactive", { fg = c.overlay0 })
      end
      set_harpoon_hl()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_harpoon_hl })

      local harpoon_line = {
        icon = "󱘉",
        function()
          local list = require("harpoon"):list()
          local cur = vim.api.nvim_buf_get_name(0)

          -- split each path into segments
          local segs = {}
          for i, item in ipairs(list.items) do
            local s = {}
            for seg in item.value:gmatch("[^/]+") do
              s[#s + 1] = seg
            end
            segs[i] = s
          end

          -- shortest trailing N segments of item i
          local function suffix(i, n)
            local s = segs[i]
            return table.concat(s, "/", math.max(1, #s - n + 1))
          end

          local parts = {}
          for i, item in ipairs(list.items) do
            -- grow the suffix until it's unique among the other items
            local depth = 1
            while depth < #segs[i] do
              local s = suffix(i, depth)
              local collides = false
              for j = 1, #list.items do
                if j ~= i and suffix(j, depth) == s then
                  collides = true
                  break
                end
              end
              if not collides then
                break
              end
              depth = depth + 1
            end
            local name = suffix(i, depth)
            local active = cur:sub(-#item.value) == item.value
            local hl = active and "LualineHarpoonActive" or "LualineHarpoonInactive"
            parts[#parts + 1] = ("%%#%s#%d %s%%*"):format(hl, i, name)
          end
          return table.concat(parts, " ")
        end,
      }

      table.insert(opts.sections.lualine_x, 2, harpoon_line)
      table.insert(opts.sections.lualine_x, 3, lsp_count)

      opts.sections.lualine_y = { "location" }
      opts.sections.lualine_z = {
        {
          -- current tab position, only when more than one tab is open
          function()
            return ("%d/%d"):format(vim.fn.tabpagenr(), vim.fn.tabpagenr("$"))
          end,
          icon = "󰓩",
          cond = function()
            return vim.fn.tabpagenr("$") > 1
          end,
        },
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
