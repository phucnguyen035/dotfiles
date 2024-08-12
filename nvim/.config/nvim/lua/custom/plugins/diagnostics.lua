return {
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
}
