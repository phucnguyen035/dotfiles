local function has_tailwind_lsp()
  local clients = vim.lsp.get_clients { name = 'tailwindcss' }
  local results = #clients > 0

  return results
end

return {
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    opts = {
      history = true,
      region_check_events = 'InsertEnter',
      delete_check_events = 'TextChanged,InsertLeave',
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  {
    'hrsh7th/nvim-cmp',
    cond = not vim.g.vscode,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'
      local luasnip = require 'luasnip'
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        preselect = cmp.PreselectMode.None,

        mapping = {
          ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
          ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-q>'] = cmp.mapping.close(),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping {
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                if luasnip.expandable() then
                  luasnip.expand()
                else
                  cmp.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                  }
                end
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm { select = true },
            c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },

        formatting = has_tailwind_lsp() and {
          format = lspkind.cmp_format {
            before = require('tailwind-tools.cmp').lspkind_format,
          },
        } or nil,

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'lazydev', group_index = 0 },
        }, {
          { name = 'buffer' },
        }),
      }
    end,
  },
}
