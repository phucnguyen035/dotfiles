return {
  {
    'zbirenbaum/copilot.lua',
    cond = not vim.g.vscode,
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        auto_trigger = true,
      },
      filetypes = {
        yaml = true,
      },
    },
  },
  {
    'olimorris/codecompanion.nvim',
    event = 'BufRead',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
    },
    opts = {
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').use('anthropic', {
            env = {
              api_key = 'cmd:op read op://Personal/CodeCompanion/credential --no-newline',
            },
          })
        end,
        openai = function()
          return require('codecompanion.adapters').use('openai', {
            env = {
              api_key = 'cmd:op read op://Personal/CodeCompanion/openai --no-newline',
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'openai',
        },
      },
    },
  },
}
