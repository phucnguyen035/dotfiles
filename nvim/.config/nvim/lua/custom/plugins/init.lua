return {
  -- Linter
  {
    'mfussenegger/nvim-lint',
    cond = not vim.g.vscode,
    event = 'BufRead',
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        go = { 'golangcilint' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set('n', '<leader>cl', function()
        lint.try_lint()
      end, { desc = 'Trigger [C]ode [L]inting for current file' })
    end,
  },
  -- Formatter
  {
    'stevearc/conform.nvim',
    cond = not vim.g.vscode,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo', 'Format', 'FormatToggle', 'FormatStatus' },
    config = function(_, opts)
      local conform = require 'conform'
      conform.setup(opts)

      vim.api.nvim_create_user_command('Format', function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
          }
        end
        conform.format {
          range,
          async = true,
          lsp_format = 'fallback',
        }
      end, { range = true })

      vim.api.nvim_create_user_command('FormatToggle', function(args)
        if args.bang then
          local current = vim.b.disable_autoformat
          local next = not current
          -- FormatToggle! will disable formatting just for this buffer
          vim.b.disable_autoformat = next
          vim.notify('Autoformat ' .. (next and 'disabled' or 'enabled') .. ' (buffer)')
        else
          local current = vim.g.disable_autoformat
          local next = not current
          vim.g.disable_autoformat = next
          vim.notify('Autoformat ' .. (next and 'disabled' or 'enabled') .. '(global)')
        end
      end, {
        desc = 'Toggle autoformat-on-save',
        bang = true,
      })

      vim.api.nvim_create_user_command('FormatStatus', function()
        if vim.b.disable_autoformat == true then
          vim.notify 'Autoformat disabled (buffer)'
        elseif vim.g.disable_autoformat == true then
          vim.notify 'Autoformat disabled (global)'
        else
          vim.notify 'Autoformat enabled'
        end
      end, {
        desc = 'Show autoformat status',
      })
    end,
    opts = function()
      local formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'gofumpt', 'goimports', 'golines' },
      }

      local frontend = {
        'astro',
        'css',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'html',
      }

      for _, ft in ipairs(frontend) do
        formatters_by_ft[ft] = { 'prettierd', 'biome', stop_after_first = true }
      end

      return {
        notify_on_error = false,
        formatters_by_ft,
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          return {
            timeout_ms = 500,
            lsp_format = 'fallback'
          }
        end,
      }
    end,
  },
  -- Diagnostics
  {
    'folke/trouble.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Trouble',
    opts = {
      focus = true,
      modes = {
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
      },
    },
    config = function(_, opts)
      require('trouble').setup(opts)

      -- Open Trouble Quickfix List when opening a quickfix window
      -- NOTE: This will block quickflix list for other things
      vim.api.nvim_create_autocmd('BufRead', {
        callback = function(ev)
          if vim.bo[ev.buf].buftype == 'quickfix' then
            vim.schedule(function()
              vim.cmd [[cclose]]
              vim.cmd [[Trouble qflist open]]
            end)
          end
        end,
      })
    end,
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
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
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    event = 'BufRead',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' },  -- for curl, log wrapper
    },
    opts = {
      mappings = {
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
        complete = {
          insert = '',
        },
      },
    },
    config = function(_, opts)
      require('CopilotChat.integrations.cmp').setup()
      require('CopilotChat').setup(opts)
    end,
    keys = {
      {
        '<leader>cco',
        function()
          require('CopilotChat').open()
        end,
        desc = 'CopilotChat - Open',
      },
      {
        '<leader>ccq',
        function()
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
            end
          end)
        end,
        desc = 'CopilotChat - Quick chat',
      },
      {
        '<leader>ccp',
        function()
          local actions = require 'CopilotChat.actions'
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        mode = { 'n', 'v', 'x' },
        desc = 'CopilotChat - Prompt actions',
      },
    },
  },
  -- Zen Mode
  {
    'folke/zen-mode.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'folke/twilight.nvim' },
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 1,
        width = 150,
      },
      plugins = {
        twilight = { enabled = true },
        tmux = { enabled = true },
        wezterm = { enabled = true, font = 15 },
      },
    },
    keys = {
      { 'gz', '<cmd>ZenMode<cr>', desc = '[G]o [Z]en Mode', silent = true },
    },
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
    opts = {
      override = {
        postcss = {
          icon = '',
          color = '#5293CB',
          name = 'PostCSS',
        },
      },
    },
  },
}
