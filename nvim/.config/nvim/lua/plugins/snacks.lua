return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    notifier = {
      level = vim.log.levels.ERROR,
    },
    scroll = {
      animate = {
        fps = 120,
      },
    },
    -- picker = {
    --   sources = {
    --     files = { hidden = true },
    --     explorer = { hidden = true },
    --   },
    -- },
  },
}
