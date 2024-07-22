vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { noremap = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
-- DISABLED because of nvim-tmux-navigation
-- map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
-- map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
-- map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
-- map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

map('i', 'jk', '<ESC>', { desc = 'Exit insert mode', nowait = true })
map('i', '<C-h>', '<Left>', { desc = 'Move left' })
map('i', '<C-l>', '<Right>', { desc = 'Move right' })
map('i', '<C-k>', '<Up>', { desc = 'Move up' })
map('i', '<C-j>', '<Down>', { desc = 'Move down' })
map('i', '<C-b>', '<ESC><S-i>', { desc = 'Insert mode at beginning of char' })
map('i', '<C-e>', '<ESC><S-a>', { desc = 'Insert mode at end of char' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Jump half page down and keep cursor centered' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Jump half page up and keep cursor centered' })
map('n', 'n', 'nzzzv', { desc = 'Keep cursor centered when moving to next search result' })
map('n', 'N', 'Nzzzv', { desc = 'Keep cursor centered when moving to previous search result' })
map('n', '<M-o>', '@="m`o<C-V><Esc>``"<CR>', { desc = 'Insert newline below', silent = true })
map('n', '<M-O>', '@="m`O<C-V><Esc>``"<CR>', { desc = 'Insert newline above', silent = true })
map('x', 'zV', 'zMzO', { desc = 'Close all except current cursor line', silent = true })
map('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })
map('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', '<leader>qq', '<cmd>qall<cr>', { desc = 'Quit all' })
map({ 'n', 'i', 'x', 's' }, '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })

if vim.g.vscode then
  map('n', '<leader><space>', '<cmd>Find<cr>')
  map('n', '<leader>fe', [[<cmd>call VSCodeNotify('workbench.view.explorer')<cr>]])
  map('n', '<leader>/', [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
  map('n', '<leader>ss', [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
  map('n', '<leader>gg', [[<cmd>call VSCodeNotify('workbench.scm.focus')<cr>]])
  map('n', '<leader>pp', [[<cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>]])
  map('n', '<leader>ps', [[<cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<cr>]])
  map('n', 'za', [[<cmd>call VSCodeNotify('editor.toggleFold')<cr>]])
  map('n', 'zR', [[<cmd>call VSCodeNotify('editor.unfoldAll')<cr>]])
  map('n', 'zM', [[<cmd>call VSCodeNotify('editor.foldAll')<cr>]])
  map('n', 'zo', [[<cmd>call VSCodeNotify('editor.unfold')<cr>]])
  map('n', 'zO', [[<cmd>call VSCodeNotify('editor.unfoldRecursively')<cr>]])
  map('n', 'zc', [[<cmd>call VSCodeNotify('editor.fold')<cr>]])
  map('n', 'zC', [[<cmd>call VSCodeNotify('editor.foldRecursively')<cr>]])
  map('v', 'zV', [[<cmd>call VSCodeNotify('editor.foldAllExcept')<cr>]])
end
