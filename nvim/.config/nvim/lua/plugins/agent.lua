-- Agent CLI helpers: yank file references as @-mentions to the system clipboard.
-- Keys-only spec (attached to LazyVim) so the maps lazy-load on first use.

-- Above this many selected lines, fall back to header only (@path (Lx-y)) and
-- let the agent read the file itself instead of dumping the block into the clipboard.
local AGENT_YANK_MAX_LINES = 200

local function agent_relpath()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end
  local root = vim.fs.root(0, ".git") or vim.uv.cwd()
  return vim.fs.relpath(root, file) or vim.fn.fnamemodify(file, ":.")
end

-- Yank current file path (relative to project root) as an @-mention
local function yank_path()
  local rel = agent_relpath()
  if not rel then
    vim.notify("No file in buffer", vim.log.levels.WARN)
    return
  end
  local mention = "@" .. rel
  vim.fn.setreg("+", mention)
  vim.notify("Copied " .. mention)
end

-- Yank the selected lines as an @-mention header + fenced code block
local function yank_selection()
  local rel = agent_relpath()
  if not rel then
    vim.notify("No file in buffer", vim.log.levels.WARN)
    return
  end
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end
  local range = s == e and ("L" .. s) or ("L" .. s .. "-" .. e)
  local header = ("@%s (%s)"):format(rel, range)
  local count = e - s + 1
  if count > AGENT_YANK_MAX_LINES then
    vim.fn.setreg("+", header)
    vim.notify(("Copied %s (header only, %d lines)"):format(header, count))
  else
    local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
    local block = table.concat({
      header,
      "```" .. (vim.bo.filetype ~= "" and vim.bo.filetype or ""),
      table.concat(lines, "\n"),
      "```",
    }, "\n")
    vim.fn.setreg("+", block)
    vim.notify(("Copied %s"):format(header))
  end
  -- leave visual mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

return {
  "LqazyVim/LazyVim",
  keys = {
    { "<leader>aY", yank_path, mode = "n", desc = "Agent: yank buffer" },
    { "<leader>ay", yank_selection, mode = "x", desc = "Agent: yank selection" },
  },
}
