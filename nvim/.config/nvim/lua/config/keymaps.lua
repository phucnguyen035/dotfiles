-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local map = vim.keymap.set
local unmap = vim.keymap.del

-- Disable LazyVim default keymaps
unmap("n", "<leader>wd")
unmap("n", "<leader>wm")

-- Additional keymaps here
map("i", "jk", "<ESC>", { desc = "Exit insert mode", nowait = true })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-b>", "<ESC><S-i>", { desc = "Insert mode at beginning of char" })
map("i", "<C-e>", "<ESC><S-a>", { desc = "Insert mode at end of char" })
-- incompatble with which-key
-- map("n", "<C-d>", "<C-d>zz", { desc = "Jump half page down and keep cursor centered" })
-- map("n", "<C-u>", "<C-u>zz", { desc = "Jump half page up and keep cursor centered" })
map("n", "n", "nzzzv", { desc = "Keep cursor centered when moving to next search result" })
map("n", "N", "Nzzzv", { desc = "Keep cursor centered when moving to previous search result" })
map("n", "<M-o>", '@="m`o<C-V><Esc>``"<CR>', { desc = "Insert newline below", silent = true })
map("n", "<M-O>", '@="m`O<C-V><Esc>``"<CR>', { desc = "Insert newline above", silent = true })
map("x", "zV", "zMzO", { desc = "Close all except current cursor line", silent = true })
map("n", "<leader>qq", "<cmd>qall<cr>", { desc = "Quit all" })
map("n", "<leader>r", "<cmd>e<cr>", { desc = "Reload file" })
map("n", "<leader>R", "<cmd>e!<cr>", { desc = "Reload file (force)", silent = true, nowait = true })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Smart splits
local splits = require("smart-splits")

map("n", "<C-h>", splits.move_cursor_left)
map("n", "<C-j>", splits.move_cursor_down)
map("n", "<C-k>", splits.move_cursor_up)
map("n", "<C-l>", splits.move_cursor_right)
map("n", "<C-\\>", splits.move_cursor_previous)
map("n", "<A-h>", splits.resize_left)
map("n", "<A-j>", splits.resize_down)
map("n", "<A-k>", splits.resize_up)
map("n", "<A-l>", splits.resize_right)
