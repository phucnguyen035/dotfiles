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
      default_prompts = {
        ['Generate a Commit Message'] = {
          prompts = {
            {
              role = '${user}',
              contains_code = true,
              content = function()
                return 'You are an expert at following the Conventional Commit specification. Be short and concise. Do not capitalize. Given the git diff listed below, please generate a commit message for me:'
                  .. '\n\n```\n'
                  .. vim.fn.system 'git diff --staged'
                  .. '\n```'
              end,
            },
          },
        },
      },
    },
    keys = {
      { '<leader>tc', '<cmd>CodeCompanionToggle<cr>', desc = 'Toggle Code companion' },
    },
  },
}
