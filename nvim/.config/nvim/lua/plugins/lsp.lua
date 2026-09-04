-- TypeScript 7 ships its own language server (`tsc --lsp`), older TypeScript
-- needs `vtsls`. `lsp/tsc.lua` gates itself on 7+, but happily falls back to a
-- `tsc` on `$PATH` (mason installs one) when the project's own is older, which
-- would attach both servers. Gate each on the version the project actually uses.
local ts_modern_cache = {} ---@type table<string, boolean>
local ts_modern_pending = {} ---@type table<string, fun(modern: boolean)[]>

---@param root string
---@return string|nil
local function tsc_bin(root)
  for _, bin in ipairs({ vim.fs.joinpath(root, "node_modules/.bin/tsc"), "tsc" }) do
    if vim.fn.executable(bin) == 1 then
      return bin
    end
  end
end

--- Whether the TypeScript serving `root` is its own language server (7+).
--- An unusable or unreadable `tsc` counts as modern: there is nothing older in
--- play, so `vtsls` stays out and `lsp/tsc.lua`'s own 7+ check — which also
--- considers `tsgo` — has the last word.
---
--- Cached per binary rather than per root: a `$PATH` `tsc` is the same binary in
--- every project, and the `tsc` and `vtsls` gates ask about one root at once, so
--- late arrivals queue behind the first spawn instead of starting their own.
---@param root string
---@param cb fun(modern: boolean)
local function ts_modern(root, cb)
  local bin = tsc_bin(root)
  if not bin then
    return cb(true)
  end
  local cached = ts_modern_cache[bin]
  if cached ~= nil then
    return cb(cached)
  end
  local pending = ts_modern_pending[bin]
  if pending then
    pending[#pending + 1] = cb
    return
  end
  ts_modern_pending[bin] = { cb }
  vim.system({ bin, "--version" }, { text = true }, function(res)
    local version = res.code == 0 and vim.version.parse(res.stdout or "") or nil
    local modern = version == nil or version.major >= 7
    ts_modern_cache[bin] = modern
    local waiting = ts_modern_pending[bin]
    ts_modern_pending[bin] = nil
    vim.schedule(function()
      for _, waiter in ipairs(waiting) do
        waiter(modern)
      end
    end)
  end)
end

--- Wrap a server's default `root_dir` so it only attaches where `gate` agrees.
--- Only valid from inside `opts`: the default has to be read after
--- nvim-lspconfig puts `lsp/<name>.lua` on the runtimepath, but before LazyVim
--- merges these opts back into `vim.lsp.config` — otherwise the wrapper would
--- wrap itself and stack a redundant gate layer.
---@param name string
---@param gate fun(bufnr: integer, dir: string, cb: fun(ok: boolean))
local function gated_root_dir(name, gate)
  local default = vim.lsp.config[name].root_dir
  return function(bufnr, on_dir)
    local function filter(dir)
      gate(bufnr, dir, function(ok)
        if ok then
          on_dir(dir)
        end
      end)
    end
    if type(default) == "function" then
      default(bufnr, filter)
    elseif default then
      filter(default)
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    ---@module 'nvim-lspconfig'
    ---@type PluginLspOpts
    opts = {
      codelens = {
        enabled = false,
      },
      servers = {
        -- Keep `<C-k>` as the digraph key in insert mode. Appended to LazyVim's
        -- own keys by its `opts_extend = { "servers.*.keys" }`.
        ["*"] = {
          keys = {
            { "<C-k>", false, mode = "i" },
          },
        },
        tsc = {
          settings = {
            ["js/ts"] = {
              inlayHints = {
                enumMemberValues = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = {
                  enabled = "literals",
                  suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    ---@param opts PluginLspOpts
    opts = function(_, opts)
      -- Only the gates need a function: `gated_root_dir` has to run here.
      opts.servers.tsc.root_dir = gated_root_dir("tsc", function(_, dir, cb)
        ts_modern(dir, cb)
      end)

      opts.servers.vtsls = opts.servers.vtsls or {}
      opts.servers.vtsls.root_dir = gated_root_dir("vtsls", function(_, dir, cb)
        ts_modern(dir, function(modern)
          cb(not modern)
        end)
      end)

      -- `tailwindcss`'s default root markers fall back to `.git` (Tailwind v4
      -- needs no config file), so it would attach in every git repo.
      opts.servers.tailwindcss = opts.servers.tailwindcss or {}
      opts.servers.tailwindcss.root_dir = gated_root_dir("tailwindcss", function(bufnr, _, cb)
        cb(vim.fs.root(bufnr, "node_modules/tailwindcss") ~= nil)
      end)
    end,
  },
  {
    "r4ppz/lspeek.nvim",
    opts = {
      window = {
        border = "rounded",
      },
    },
    keys = {
      {
        "gD",
        function()
          require("lspeek").peek_definition()
        end,
        desc = "Peek Definition (lspeek)",
      },
      {
        "gT",
        function()
          require("lspeek").peek_type_definition()
        end,
        desc = "Peek Type Definition (lspeek)",
      },
    },
  },
}
