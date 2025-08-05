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
  },
}
