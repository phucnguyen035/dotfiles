---@diagnostic disable: undefined-field
return {
  {
    'catppuccin/nvim',
    cond = not vim.g.vscode,
    name = 'catppuccin',
    priority = 1000,
    init = function()
      require('catppuccin').setup {
        no_italic = true,
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        integrations = {
          harpoon = true,
          lsp_trouble = true,
          treesitter = true,
          gitsigns = true,
          cmp = true,
          which_key = true,
          ufo = true,
          neogit = true,
          notify = true,
          noice = true,
          snacks = {
            enabled = true,
          },
        },
        color_overrides = {
          mocha = {
            base = '#000000',
            mantle = '#010101',
            crust = '#020202',
          },
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'nmac427/guess-indent.nvim',
    event = 'BufReadPre',
    opts = {},
  },
  {
    'folke/noice.nvim',
    lazy = true,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      routes = {
        {
          filter = {
            event = 'msg_show',
            kind = '',
            find = 'written',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            kind = '',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'lsp',
            kind = 'progress',
            cond = function(message)
              local client = vim.tbl_get(message.opts, 'progress', 'client')
              return client == 'lua_ls'
            end,
          },
          opts = { skip = true },
        },
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
        hover = {
          silent = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/noice.nvim' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto',
          component_separators = '',
          section_separators = { left = '', right = '' },
          disabled_filetypes = { 'dashboard', 'alpha', 'starter' },
        },
        extensions = {
          'quickfix',
          'lazy',
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function(str)
                return str:sub(1, 1)
              end,
            },
          },

          lualine_b = {
            {
              'branch',
              fmt = function(str)
                local max_length = 30
                if #str > max_length then
                  return str:sub(1, max_length - 3) .. '...'
                end
                return str
              end,
            },
          },

          lualine_c = {
            'diagnostics',
            'diff',
            '%=',
            { 'filename', path = 4, shorting_target = 100 },
          },

          lualine_x = {},
          lualine_y = { 'filetype', 'progress' },
          lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
          },
        },
      }
    end,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {},
  },
}
