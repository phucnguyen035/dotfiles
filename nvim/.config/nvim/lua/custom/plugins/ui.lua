return {
  {
    'catppuccin/nvim',
    cond = not vim.g.vscode,
    name = 'catppuccin',
    priority = 1000,
    init = function()
      require('catppuccin').setup {
        transparent_background = true,
        dim_inactive = {
          enabled = true,
          shade = 'dark',
          percentage = 0.15,
        },
        integrations = {
          harpoon = true,
          lsp_trouble = true,
          treesitter = true,
          gitsigns = true,
          telescope = true,
          cmp = true,
          which_key = true,
          ufo = true,
          neogit = true,
          notify = true,
          noice = true,
          indent_blankline = {
            enabled = true,
            scope_color = 'lavender',
            colored_indent_levels = false,
          },
        },
      }

      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'stevearc/dressing.nvim',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    opts = {},
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
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'folke/noice.nvim', 'AndreM222/copilot-lualine' },
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
            'branch',
          },

          lualine_b = {
            'diagnostics',
          },

          lualine_c = {
            'diff',
            '%=',
            { 'filename', path = 1, shorting_target = 10 },
          },

          lualine_x = {
            {
              require('noice').api.statusline.mode.get,
              cond = require('noice').api.statusline.mode.has,
              color = { fg = '#ff9e64' },
            },
            'copilot',
          },
          lualine_y = { 'filetype', 'progress' },
          lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
          },
        },
      }
    end,
  },
}
