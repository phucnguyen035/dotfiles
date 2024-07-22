return {
  'folke/which-key.nvim',
  cond = not vim.g.vscode,
  event = 'VeryLazy',
  opts = {
    spec = {
      { '<leader>q', group = 'quit' },
      { '<leader>c', group = 'code/copilot' },
      { '<leader>cc', group = 'chat', icon = ' ' },
      { '<leader>ct', group = 'toggle' },
      { '<leader>f', group = 'file' },
      { '<leader>s', group = 'search' },
      { '<leader>g', group = 'git' },
      { '<leader>b', group = 'buffer' },
      { '<leader>x', group = 'trouble' },
      { '<leader><tab>', group = 'tab' },
      { '<leader>w', group = 'workspace' },
      { '<leader>t', group = 'toggle' },
      { '<leader>cf', '<cmd>Format<cr>', desc = 'Format code', mode = { 'n', 'v' } },
      { '<leader>tf', '<cmd>FormatToggle<cr>', desc = 'Toggle format (global)' },
      { '<leader>tF', '<cmd>FormatToggle!<cr>', desc = 'Toggle format (buffer)' },
      { '<leader>bb', '<cmd>b#<cr>', desc = 'Switch to last buffer' },
      { '<leader>bc', '<cmd>WipeWindowlessBufs<cr>', desc = 'Clear all buffers, keep current', silent = true },
      { '<leader><tab>f', '<cmd>tabfirst<cr>', desc = 'Go to first tab' },
      { '<leader><tab>l', '<cmd>tablast<cr>', desc = 'Go to last tab' },
      { '<leader><tab>n', '<cmd>tabnew<cr>', desc = 'New tab' },
      { '<leader><tab>d', '<cmd>tabclose<cr>', desc = 'Remove tab' },
      { '<leader><tab>o', '<cmd>tabonly<cr>', desc = 'Close other tabs' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
