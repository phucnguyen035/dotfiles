local ftMap = {
  vim = 'indent',
  python = { 'indent' },
  git = '',
}

-- lsp -> treesitter -> indent
---@param bufnr number
---@return Promise
local function customizeSelector(bufnr)
  local function handleFallbackException(err, providerName)
    if type(err) == 'string' and err:match 'UfoFallbackException' then
      return require('ufo').getFolds(bufnr, providerName)
    else
      return require('promise').reject(err)
    end
  end

  return require('ufo')
    .getFolds(bufnr, 'lsp')
    :catch(function(err)
      return handleFallbackException(err, 'treesitter')
    end)
    :catch(function(err)
      return handleFallbackException(err, 'indent')
    end)
end

return {
  'kevinhwang91/nvim-ufo',
  cond = not vim.g.vscode,
  dependencies = 'kevinhwang91/promise-async',
  event = 'BufRead',
  config = function()
    require('ufo').setup {
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
      },
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']',
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return ftMap[filetype] or customizeSelector
      end,
    }

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
    vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set('n', 'zk', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
