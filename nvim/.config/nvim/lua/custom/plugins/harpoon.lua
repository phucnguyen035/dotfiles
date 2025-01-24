return {
  'ThePrimeagen/harpoon',
  cond = not vim.g.vscode,
  branch = 'harpoon2',
  dependencies = 'nvim-lua/plenary.nvim',
  opts = {},
  keys = {
    {
      '<leader>ma',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'Harpoon: Add File',
    },
    {
      '<leader>mm',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Harpoon: Quick Menu',
    },
  },
}
