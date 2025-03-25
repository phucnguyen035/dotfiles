return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false,
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'hrsh7th/nvim-cmp',
      'nvim-tree/nvim-web-devicons',
      'ibhagwan/fzf-lua',
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'Avante' },
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
      },
    },
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- claude = {
      --   api_key_name = 'cmd:op read op://Personal/CodeCompanion/credential --no-newline',
      -- },
      behaviour = {
        enable_claude_text_editor_tool_mode = true,
      },
    },
  },
}
