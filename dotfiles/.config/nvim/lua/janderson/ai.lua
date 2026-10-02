-----------------------------------
--- Working alongside AI agents
-----------------------------------

-- Pick up edits agents (or git, codegen, ...) make on disk. 'autoread' is on by
-- default but only acts when Neovim checks; FocusGained needs tmux's
-- `focus-events on`.
local group = vim.api.nvim_create_augroup("agent_reload", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  group = group,
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd.checktime()
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = group,
  callback = function(args)
    vim.notify("Reloaded from disk: " .. vim.fn.fnamemodify(args.file, ":~:."), vim.log.levels.INFO)
  end,
})

-- Window navigation out of terminal buffers (Claude, REPLs), tmux-aware
vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function(args)
    if vim.api.nvim_buf_get_name(args.buf):match("fzf") then
      return -- fzf uses <C-j>/<C-k> to move through results
    end
    for key, dir in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
      vim.keymap.set("t", "<C-" .. key .. ">", "<Cmd>TmuxNavigate" .. dir .. "<CR>", { buffer = args.buf })
    end
  end,
})

-- claudecode.nvim runs the same IDE (MCP over websocket) server as the VS Code
-- and JetBrains extensions. Claude sees the current file/selection, can read
-- LSP diagnostics, and proposes edits as native diffs (:w accept, :q reject).
-- It works both with the split below and with `claude` started in another
-- tmux pane: run `/ide` there to connect to this Neovim.
require("claudecode").setup({
  log_level = "warn",
  terminal = {
    provider = "native",
    split_side = "right",
    split_width_percentage = 0.35,
    git_repo_cwd = true, -- start Claude at the repo root, not nvim-tree's cwd
  },
  diff_opts = {
    layout = "vertical",
    open_in_new_tab = false,
  },
})

-- `@path#L10-20` for the buffer (normal) or selection (visual), so a location
-- can be pasted into any agent prompt: Claude in a tmux pane, a PR comment, ...
local function reference()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local first, last = vim.fn.line("v"), vim.fn.line(".")
    if first > last then
      first, last = last, first
    end
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    return first == last and ("@%s#L%d"):format(path, first) or ("@%s#L%d-%d"):format(path, first, last)
  end
  return "@" .. path
end

local map = vim.keymap.set
map("n", "<leader>ac", "<Cmd>ClaudeCode<CR>", { desc = "Toggle Claude" })
map("n", "<leader>af", "<Cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude" })
map("n", "<leader>aC", "<Cmd>ClaudeCode --continue<CR>", { desc = "Continue last conversation" })
map("n", "<leader>ar", "<Cmd>ClaudeCode --resume<CR>", { desc = "Resume a conversation" })
map("n", "<leader>am", "<Cmd>ClaudeCodeSelectModel<CR>", { desc = "Select model" })
map("n", "<leader>ab", "<Cmd>ClaudeCodeAdd %<CR>", { desc = "Add buffer to context" })
map("x", "<leader>as", "<Cmd>ClaudeCodeSend<CR>", { desc = "Send selection to Claude" })
map("n", "<leader>aa", "<Cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept Claude's diff" })
map("n", "<leader>ad", "<Cmd>ClaudeCodeDiffDeny<CR>", { desc = "Reject Claude's diff" })
map("n", "<leader>aS", "<Cmd>ClaudeCodeStatus<CR>", { desc = "Connection status" })
map({ "n", "x" }, "<leader>ay", function()
  local ref = reference()
  vim.fn.setreg("+", ref)
  vim.notify("Copied " .. ref)
end, { desc = "Copy @reference" })
map("n", "<leader>ae", function()
  -- Claude reads the diagnostics itself via the IDE connection; this just
  -- starts the prompt (not submitted, so it can be edited first)
  if not require("claudecode").is_claude_connected() then
    vim.notify("Claude is not connected: <leader>ac, or /ide in a tmux pane", vim.log.levels.WARN)
    return
  end
  vim.cmd("ClaudeCodeSendText! Fix the diagnostics in " .. reference() .. " ")
  vim.cmd("ClaudeCodeFocus")
end, { desc = "Ask Claude to fix diagnostics" })
