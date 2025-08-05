-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Move to window using the <ctrl> hjkl keys
-- DISABLED because of nvim-tmux-navigation
-- map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
-- map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
-- map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
-- map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

map("i", "jk", "<ESC>", { desc = "Exit insert mode", nowait = true })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-b>", "<ESC><S-i>", { desc = "Insert mode at beginning of char" })
map("i", "<C-e>", "<ESC><S-a>", { desc = "Insert mode at end of char" })
map("n", "<C-d>", "<C-d>zz", { desc = "Jump half page down and keep cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Jump half page up and keep cursor centered" })
map("n", "n", "nzzzv", { desc = "Keep cursor centered when moving to next search result" })
map("n", "N", "Nzzzv", { desc = "Keep cursor centered when moving to previous search result" })
map("n", "<M-o>", '@="m`o<C-V><Esc>``"<CR>', { desc = "Insert newline below", silent = true })
map("n", "<M-O>", '@="m`O<C-V><Esc>``"<CR>', { desc = "Insert newline above", silent = true })
map("x", "zV", "zMzO", { desc = "Close all except current cursor line", silent = true })
map("n", "<leader>qq", "<cmd>qall<cr>", { desc = "Quit all" })
map("n", "<leader>r", "<cmd>e<cr>", { desc = "Reload file" })
map("n", "<leader>R", "<cmd>e!<cr>", { desc = "Reload file (force)", silent = true, nowait = true })
