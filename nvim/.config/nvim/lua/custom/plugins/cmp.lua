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
    lazy = true,
    opts = {},
  },
  {
    'hrsh7th/nvim-cmp',
    cond = not vim.g.vscode,
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local types = require 'cmp.types'
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
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm { select = true },
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },

        formatting = {
          format = lspkind.cmp_format {
            before = function(entry, item)
              if has_tailwind_lsp() then
                require('tailwind-tools.cmp').lspkind_format(entry, item)
              end

              return item
            end,
          },
        },

        sources = cmp.config.sources({
          {
            name = 'nvim_lsp',
            entry_filter = function(entry)
              local kind = entry:get_kind()
              -- Filter out lsp snippets
              if kind == types.lsp.CompletionItemKind.Snippet then
                return false
              end

              return true
            end,
          },
          { name = 'luasnip' },
          { name = 'lazydev', group_index = 0 },
        }, {
          { name = 'buffer' },
        }),

        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.scopes,
            cmp.config.compare.exact,
            cmp.config.compare.offset,
            cmp.config.compare.sort_text,
          },
        },
      }

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })
    end,
  },
}
