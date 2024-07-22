return {
  'folke/todo-comments.nvim',
  cmd = 'TodoTrouble',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
  keys = {
    { '<leader>st', '<cmd>TodoTrouble<cr>', desc = 'Search todos in Trouble' },
  },
}
