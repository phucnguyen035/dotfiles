local nmap = function(key, cmd, opts)
  vim.keymap.set('n', key, cmd, opts)
end

return {
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    opts = {},
    config = function(_, opts)
      local smart_splits = require 'smart-splits'
      smart_splits.setup(opts)

      nmap('<C-h>', smart_splits.move_cursor_left)
      nmap('<C-j>', smart_splits.move_cursor_down)
      nmap('<C-k>', smart_splits.move_cursor_up)
      nmap('<C-l>', smart_splits.move_cursor_right)
      nmap('<C-\\>', smart_splits.move_cursor_previous)

      nmap('<A-h>', smart_splits.resize_left)
      nmap('<A-j>', smart_splits.resize_down)
      nmap('<A-k>', smart_splits.resize_up)
      nmap('<A-l>', smart_splits.resize_right)

      nmap('<leader>bh', smart_splits.swap_buf_left, { desc = 'Swap buffer left' })
      nmap('<leader>bj', smart_splits.swap_buf_down, { desc = 'Swap buffer down' })
      nmap('<leader>bk', smart_splits.swap_buf_up, { desc = 'Swap buffer up' })
      nmap('<leader>bl', smart_splits.swap_buf_right, { desc = 'Swap buffer right' })
    end,
  },
}
