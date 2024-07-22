return {
  {
    'echasnovski/mini.files',
    cond = not vim.g.vscode,
    version = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local mf = require 'mini.files'
      mf.setup {
        windows = {
          preview = true,
          width_preview = 80,
        },
      }
      local show_dotfiles = true
      local filter_show = function()
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        mf.refresh { content = { filter = new_filter } }
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id, desc = 'Toggle dotfiles visibility' })
        end,
      })

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local new_target_window
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.api.nvim_win_call(mf.get_target_window(), function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target_window)
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          map_split(buf_id, 'gs', 'belowright horizontal')
          map_split(buf_id, 'gv', 'belowright vertical')
        end,
      })
    end,
    keys = {
      {
        '<leader>e',
        function()
          local mf = require 'mini.files'
          local path = vim.api.nvim_buf_get_name(0)
          -- Get latest path if path ends with /Starter
          if path:sub(-8) == '/Starter' then
            path = mf.get_latest_path()
          end

          mf.open(path)
        end,
        desc = 'Open mini.files',
        silent = true,
      },
      {
        '<leader>E',
        function()
          require('mini.files').open(nil, false)
        end,
        desc = 'Open mini.files (cwd)',
      },
    },
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    cond = not vim.g.vscode,
    event = 'InsertEnter',
    opts = {},
  },
  {
    'echasnovski/mini.bufremove',
    version = false,
    event = 'BufRead',
    opts = {},
    keys = {
      {

        '<leader>bd',
        function()
          require('mini.bufremove').delete()
        end,
        desc = 'Delete buffer',
      },
    },
  },
  {
    'echasnovski/mini.cursorword',
    cond = not vim.g.vscode,
    event = 'BufRead',
    version = false,
    opts = {},
  },
  {
    'echasnovski/mini.surround',
    version = false,
    event = { 'BufNewFile', 'BufRead' },
    opts = {
      mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    },
  },
  {
    'echasnovski/mini.starter',
    version = false,
    cond = not vim.g.vscode,
    event = 'VimEnter',
    opts = function()
      local starter = require 'mini.starter'
      return {
        header = [[
         _____  ___    _______    ______  ___      ___  __     ___      ___
        (\"   \|"  \  /"     "|  /    " \|"  \    /"  ||" \   |"  \    /"  |
        |.\\   \    |(: ______) // ____  \\   \  //  / ||  |   \   \  //   |
        |: \.   \\  | \/    |  /  /    ) :)\\  \/. ./  |:  |   /\\  \/.    |
        |.  \    \. | // ___)_(: (____/ //  \.    //   |.  |  |: \.        |
        |    \    \ |(:      "|\        /    \\   /    /\  |\ |.  \    /:  |
         \___|\____\) \_______) \"_____/      \__/    (__\_|_)|___|\__/|___|
        ]],
        evaluate_single = true,
        items = {
          { name = 'Find files', action = 'Telescope find_files', section = 'Telescope' },
          { name = 'Recent files', action = "lua require('telescope.builtin').oldfiles({ cwd_only = true })", section = 'Telescope' },
          { name = 'Grep text', action = 'Telescope live_grep', section = 'Telescope' },
          { name = 'Harpoon marks', action = "lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())", section = 'Telescope' },
          { name = 'Plugin', action = 'Lazy', section = 'Config' },
          { name = 'Mason', action = 'Mason', section = 'Config' },
          { name = 'Session restore', action = "lua require('persistence').load()", section = 'Session' },
          { name = 'Quit', action = 'qa', section = 'System' },
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning('center', 'center'),
        },
        footer = function()
          return "Let's get started!"
        end,
      }
    end,
  },
}
