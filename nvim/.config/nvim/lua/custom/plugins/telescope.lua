-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  cond = not vim.g.vscode,
  cmd = 'Telescope',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  opts = {
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    defaults = {
      path_display = { 'smart' },
      layout_strategy = 'flex',
      mappings = {
        n = {
          ['q'] = 'close',
        },
        i = {
          ['<C-q>'] = 'close',
        },
      },
    },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
    },
  },
  config = function(_, opts)
    local telescope = require 'telescope'
    telescope.setup(opts)
    telescope.load_extension 'fzf'
  end,
  keys = {
    {
      '<leader>:',
      '<cmd>Telescope command_history<cr>',
      desc = 'Command history',
    },
    {
      '<leader>fr',
      '<cmd>Telescope oldfiles cwd_only=true<cr>',
      desc = 'Find recent files (cwd)',
    },
    {
      '<leader>,',
      '<cmd>Telescope buffers sort_mru=true sort_lastused=true cwd_only=true<cr>',
      desc = 'Find buffers',
    },
    {
      '<leader><space>',
      '<cmd>Telescope find_files<cr>',
      desc = 'Find files from project root',
    },
    {
      '<leader>fg',
      '<cmd>Telescope git_files<cr>',
      desc = 'Find git files',
    },
    {
      '<leader>sh',
      '<cmd>Telescope help_tags<cr>',
      desc = 'Search help pages',
    },
    {
      '<leader>sg',
      '<cmd>Telescope live_grep<cr>',
      desc = 'Grep',
    },
    {
      '<leader>sw',
      '<cmd>Telescope grep_string word_match=-w<cr>',
      desc = 'Search current word',
    },
    {
      '<leader>sc',
      '<cmd>Telescope resume<cr>',
      desc = 'Continue search',
    },
    {
      '<leader>sb',
      '<cmd>Telescope current_buffer_fuzzy_find skip_empty_lines=true previewer=false<cr>',
      desc = 'Fuzzy search current buffer',
    },
    {
      '<leader>gb',
      '<cmd>Telescope git_branches<cr>',
      desc = 'Find git branches',
    },
  },
}
