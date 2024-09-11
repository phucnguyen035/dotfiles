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
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'cmd:op read op://Personal/CodeCompanion/credential --no-newline',
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
      },
      pre_defined_prompts = {
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
      { '<leader>A', '<cmd>CodeCompanionToggle<cr>', mode = { 'n', 'v' }, silent = true, noremap = true, desc = 'Toggle Code companion' },
      { '<leader>a', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, silent = true, noremap = true, desc = 'Code companion actions' },
      { 'ga', '<cmd>CodeCompanionAdd<cr>', mode = 'v', silent = true, noremap = true, desc = 'Add selection to chat' },
    },
  },
}
