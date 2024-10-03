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
      prompt_library = {
        ['Generate a Commit Message'] = {
          prompts = {
            {
              role = 'user',
              opts = {
                contains_code = true,
              },
              content = function()
                return string.format(
                  [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me.
The title should have at most 68 characters, and the commit body is required if there are many changes. Do not capitalize the title or body.

```diff
%s
```
]],
                  vim.fn.system 'git diff --staged'
                )
              end,
            },
          },
        },
      },
    },
    keys = {
      { '<leader>A', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, silent = true, noremap = true, desc = 'Toggle Code companion' },
      { '<leader>a', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, silent = true, noremap = true, desc = 'Code companion actions' },
      { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', silent = true, noremap = true, desc = 'Add selection to chat' },
    },
  },
}
