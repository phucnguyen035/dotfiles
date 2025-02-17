if vim.g.vscode then
  return {}
end

return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, { desc = 'Next Hunk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, { desc = 'Previous Hunk' })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage Hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset Hunk' })
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage Hunk (range)' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset Hunk (range)' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage Buffer' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset Buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview Hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, { desc = 'Blame Line' })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle Blame Line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'Diff This' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'Diff This (cached)' })
        map('n', '<leader>td', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select Hunk (inner)' })
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua',
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gs', ':Neogit<cr>', noremap = true, silent = true, desc = 'Neogit' },
      { '<leader>gc', ':Neogit commit<cr>', desc = 'Git commit', noremap = true, silent = true },
      { '<leader>gP', ':Neogit push<cr>', desc = 'Git push', noremap = true, silent = true },
      { '<leader>gp', ':Neogit pull<cr>', desc = 'Git pull', noremap = true, silent = true },
      { '<leader>gf', ':Neogit fetch<cr>', desc = 'Git fetch', noremap = true, silent = true },
      { '<leader>gr', ':Neogit rebase<cr>', desc = 'Git rebase', noremap = true, silent = true },
      { '<leader>gm', ':Neogit merge<cr>', desc = 'Git merge', noremap = true, silent = true },
      { '<leader>gZ', ':Neogit stash<cr>', desc = 'Git stash', noremap = true, silent = true },
      { '<leader>gd', ':Neogit diff<cr>', desc = 'Git diff', noremap = true, silent = true },
      { '<leader>gw', ':Neogit worktree<cr>', desc = 'Git worktree', noremap = true, silent = true },
    },
    opts = {
      console_timeout = 5000,
      integrations = {
        diffview = true,
      },
    },
  },
}
