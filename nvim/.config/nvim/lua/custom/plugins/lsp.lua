if vim.g.vscode then
  return {}
end

return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true, cmd = 'Mason' },
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
    config = function()
      -- [[ Configure LSP ]]
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(client, bufnr)
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
        end

        nmap('<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
        nmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = '[C]ode [A]ction' })

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('gs', vim.lsp.buf.signature_help, 'Signature Documentation')

        if client.name == 'eslint' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function(event)
              local diag = vim.diagnostic.count(event.buf, { severity = vim.diagnostic.severity.ERROR })
              local has_errors = next(diag) ~= nil
              if has_errors then
                vim.cmd 'EslintFixAll'
              end
            end,
          })
        end

        -- Big hack for svelte https://www.reddit.com/r/neovim/comments/1598ewp/neovim_svelte/
        if client.name == 'svelte' then
          vim.api.nvim_create_autocmd('BufWritePost', {
            pattern = { '*.js', '*.ts' },
            callback = function(ctx)
              client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.file })
            end,
          })
        end

        if client.name == 'ruff' then
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end

        if client.name == 'tailwindcss' then
          require('tailwind-tools').setup {}
        end

        if client.supports_method 'textDocument/codeLens' then
          vim.lsp.codelens.refresh { bufnr = 0 }
          vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
            pattern = '<buffer>',
            callback = function()
              vim.lsp.codelens.refresh { bufnr = 0 }
            end,
          })
        end
      end

      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      --
      --  If you want to override the default filetypes that your language server will attach to you can
      --  define the property 'filetypes' to the map in question.
      local servers = {
        -- clangd = {},
        golangci_lint_ls = {
          filetypes = { 'go', 'gomod' },
        },
        gopls = {
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },
          gopls = {
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = false,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
            semanticTokens = true,
            ['build.templateExtensions'] = { 'gohtml', 'html', 'gotmpl', 'tmpl' },
          },
        },
        rust_analyzer = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        html = {},
        emmet_language_server = {
          filetypes = {
            'html',
            'templ',
            'typescriptreact',
            'javascript',
            'javascriptreact',
            'astro',
            'vue',
            'svelte',
          },
        },
        cssls = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = 'ignore',
            },
          },
        },
        -- js stuff
        biome = {},
        astro = {},
        svelte = {},
        volar = {},
        tailwindcss = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { 'tv\\((([^()]*|\\([^()]*\\))*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
              },
            },
          },
        },
        eslint = {
          format = false,
          codeActionOnSave = {
            enable = true,
            mode = 'problems',
          },
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectories = {
            mode = 'auto',
          },
          experimental = {
            useFlatConfig = false,
          },
        },
        vtsls = {
          completions = {
            completeFunctionCalls = false,
          },
          typescript = {
            inlayHints = {
              parameterNames = {
                enabled = 'literals',
              },
            },
            implementationCodeLens = {
              enabled = true,
              -- showOnInterfaceMethods = true,
            },
            referencesCodeLens = {
              enabled = true,
              -- showOnAllFunctions = true,
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = {
                enabled = 'literals',
              },
            },
            implementationCodeLens = {
              enabled = true,
              showOnInterfaceMethods = true,
            },
            referencesCodeLens = {
              enabled = true,
              showOnAllFunctions = true,
            },
          },
        },
        -- Python
        ruff = {},
        pyright = {
          pyright = {
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
        jsonls = {
          json = {
            schemas = {
              {
                fileMatch = { 'package.json' },
                url = 'https://json.schemastore.org/package.json',
              },
              {
                fileMatch = { 'tsconfig.json' },
                url = 'https://json.schemastore.org/tsconfig.json',
              },
              {
                fileMatch = { '.eslintrc', '.eslintrc.json' },
                url = 'https://json.schemastore.org/eslintrc.json',
              },
              {
                fileMatch = { '.prettierrc', '.prettierrc.json' },
                url = 'https://json.schemastore.org/prettierrc.json',
              },
              {
                fileMatch = { '.babelrc', '.babelrc.json', 'babel.config.json' },
                url = 'https://json.schemastore.org/babelrc.json',
              },
              {
                fileMatch = { 'lerna.json' },
                url = 'https://json.schemastore.org/lerna.json',
              },
              {
                fileMatch = { 'now.json', 'vercel.json' },
                url = 'https://json.schemastore.org/now.json',
              },
              {
                fileMatch = { 'tsconfig.base.json' },
                url = 'https://json.schemastore.org/tsconfig.base.json',
              },
              {
                fileMatch = { 'tsconfig.common.json' },
                url = 'https://json.schemastore.org/tsconfig.common.json',
              },
              {
                fileMatch = { 'tsconfig.eslint.json' },
                url = 'https://json.schemastore.org/tsconfig.eslint.json',
              },
              {
                fileMatch = { 'tsconfig.jest.json' },
                url = 'https://json.schemastore.org/tsconfig.jest.json',
              },
              {
                fileMatch = { 'tsconfig.paths.json' },
                url = 'https://json.schemastore.org/tsconfig.paths.json',
              },
              {
                fileMatch = { 'tsconfig.prisma.json' },
                url = 'https://json.schemastore.org/tsconfig.prisma.json',
              },
              {
                fileMatch = { 'tsconfig.storybook.json' },
                url = 'https://json.schemastore.org/tsconfig.storybook.json',
              },
              {
                fileMatch = { 'deno.json', 'deno.jsonc' },
                url = 'https://deno.land/x/deno/cli/schemas/config-file.v1.json',
              },
            },
          },
        },
      }

      local root_config = {
        denols = function(fname)
          return vim.fs.root(fname, { 'deno.json', 'deno.jsonc' })
        end,
        vtsls = function(fname)
          if vim.fs.root(fname, { 'deno.json', 'deno.jsonc' }) then
            return nil
          end

          return vim.fs.root(fname, { 'tsconfig.json', 'package.json', 'jsconfig.json' })
        end,
      }

      local single_file_config = {
        vtsls = false,
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.workspace.didChangeWatchedFiles = {
        dynamicRegistration = true,
        relativePatternSupport = true,
      }

      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
            root_dir = root_config[server_name],
            single_file_support = single_file_config[server_name],
          }
        end,
      }

      -- Whenever an LSP attaches to a buffer, we will run this function.
      -- See `:help LspAttach` for more information about this autocmd event.
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client_id = args.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)
          if not client then
            return
          end

          if client.supports_method 'textDocument/inlayHint' then
            vim.keymap.set('n', '<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { buffer = args.buffer })
            end, { buffer = args.buffer, desc = 'Toggle inlay hints' })
          end

          -- Only attach to clients that support document formatting
          if not client.supports_method 'textDocument/formatting' then
            return
          end

          if client.name == 'vtsls' then
            vim.keymap.set('n', '<leader>cu', function()
              vim.lsp.buf.code_action {
                apply = true,
                context = {
                  ---@diagnostic disable-next-line: assign-type-mismatch
                  only = { 'source.removeUnused.ts' },
                  diagnostics = {},
                },
              }
            end, { buffer = args.buffer, desc = 'Remove unused' })
          end

          -- Big hack for svelte https://www.reddit.com/r/neovim/comments/1598ewp/neovim_svelte/
          vim.api.nvim_create_autocmd({ 'BufWrite' }, {
            pattern = { '+page.server.ts', '+page.ts', '+layout.server.ts', '+layout.ts' },
            command = 'LspRestart svelte',
          })
        end,
      })
    end,
  },
  {
    'ray-x/go.nvim',
    cond = not vim.g.vscode,
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      lsp_document_formatting = false, -- Use conform for formatting
      lsp_inlay_hints = {
        enable = false,
      },
      trouble = true,
      luasnip = true,
    },
    ft = { 'go', 'gomod', 'gohtmltmpl' },
    build = ':lua require("go.install").update_all_sync()',
  },
}
