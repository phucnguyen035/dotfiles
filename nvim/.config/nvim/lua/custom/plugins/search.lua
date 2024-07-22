return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = 'Spectre',
  opts = {
    mapping = {
      ['enter_file'] = {
        map = 'o',
        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
        desc = 'open file',
      },
    },
  },
  keys = {
    { '<leader>sr', '<cmd>lua require("spectre").toggle()<cr>', desc = 'Search and replace' },
  },
}
