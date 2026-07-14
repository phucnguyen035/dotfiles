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
    "nvim-mini/mini.icons",
    opts = {
      extension = {
        ["test.ts"] = { glyph = "󰙨", hl = "MiniIconsAzure" },
        ["test.tsx"] = { glyph = "󰙨", hl = "MiniIconsAzure" },
        ["test.js"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
        ["test.jsx"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
        ["spec.ts"] = { glyph = "󰙨", hl = "MiniIconsAzure" },
        ["spec.tsx"] = { glyph = "󰙨", hl = "MiniIconsAzure" },
        ["spec.js"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
        ["spec.jsx"] = { glyph = "󰙨", hl = "MiniIconsYellow" },
      },
    },
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

      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = ""

      opts.sections.lualine_a = {
        {
          "mode",
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
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

      -- in terminal buffers keep only sections a/b/y (mode, branch, location);
      -- hide everything in c/x/z (filename, navic breadcrumbs, git, tabs, …)
      local function hide_in_terminal(section)
        for i, comp in ipairs(section) do
          if type(comp) ~= "table" then
            comp = { comp }
            section[i] = comp
          end
          local prev = comp.cond
          comp.cond = function()
            if vim.bo.buftype == "terminal" then
              return false
            end
            return prev == nil or prev()
          end
        end
      end

      hide_in_terminal(opts.sections.lualine_c)
      hide_in_terminal(opts.sections.lualine_x)
      hide_in_terminal(opts.sections.lualine_z)

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
