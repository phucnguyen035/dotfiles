return {
  'folke/todo-comments.nvim',
  event = { 'BufRead', 'BufNewFile' },
  cmd = 'TodoTrouble',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
  keys = {
    { '<leader>st', '<cmd>TodoTrouble<cr>', desc = 'Search todos in Trouble' },
  },
}
