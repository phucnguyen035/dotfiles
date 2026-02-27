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
    picker = {
      win = {
        input = {
          keys = {
            ["<a-i>"] = false,
            ["<a-I>"] = { "toggle_ignored", mode = { "i", "n" } },
            ["<a-h>"] = false,
            ["<a-H>"] = { "toggle_hidden", mode = { "i", "n" } },
            ["<m-p>"] = false,
            ["<a-/>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<c-g>"] = false,
            ["<a-g>"] = { "toggle_live", mode = { "i", "n" } },
          },
        },
      },
    },
  },
}
