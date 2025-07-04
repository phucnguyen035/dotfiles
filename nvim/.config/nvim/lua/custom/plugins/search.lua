return {
  'nvim-pack/nvim-spectre',
  build = 'build.sh nvim-oxi',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  cmd = 'Spectre',
  opts = {
    use_trouble_qf = true,
    default = {
      replace = {
        cmd = 'oxi',
      },
    },
    mapping = {
      ['enter_file'] = {
        map = 'o',
        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
        desc = 'open file',
      },
    },
  },
  keys = {
    { '<leader>Sr', '<cmd>lua require("spectre").toggle()<cr>', desc = 'Search and replace' },
    { '<leader>Sb', '<cmd>lua require("spectre").open_file_search()<cr>', desc = 'Search and replace in current file' },
  },
}
