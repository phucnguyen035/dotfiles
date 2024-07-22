if vim.g.vscode then
  return {}
end

return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']h', gs.next_hunk, { desc = 'Next Hunk' })
        map('n', '[h', gs.prev_hunk, { desc = 'Previous Hunk' })
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<cr>', { desc = 'Stage Hunk' })
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<cr>', { desc = 'Reset Hunk' })
        map('n', '<leader>ghS', gs.stage_buffer, { desc = 'Stage Buffer' })
        map('n', '<leader>gha', gs.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>ghu', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
        map('n', '<leader>ghR', gs.reset_buffer, { desc = 'Reset Buffer' })
        map('n', '<leader>ghp', gs.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
        map('n', '<leader>ghb', function()
          gs.blame_line { full = true }
        end, { desc = 'Blame Line' })
        map('n', '<leader>ghd', gs.diffthis, { desc = 'Diff This' })
        map('n', '<leader>ghD', function()
          gs.diffthis '~'
        end, { desc = 'Diff This ~' })
      end,
    },
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
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
    },
  },
}
