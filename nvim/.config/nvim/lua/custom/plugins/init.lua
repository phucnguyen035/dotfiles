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
          vim.notify('Autoformat ' .. (next and 'disabled' or 'enabled') .. ' (global)')
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
        'json',
        'jsonc',
      }

      for _, ft in ipairs(frontend) do
        formatters_by_ft[ft] = { 'biome-check', 'prettierd', stop_after_first = true }
      end

      return {
        notify_on_error = true,
        formatters_by_ft = formatters_by_ft,
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end,
        formatters = {
          ['biome-check'] = {
            require_cwd = true,
          },
        },
      }
    end,
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
