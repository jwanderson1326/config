local map = vim.keymap.set

-- move selected lines
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")

-- center screen while moving fast
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- search center
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- copy paste to outside
map({ "n", "v" }, "<leader>y", "\"+y", { desc = "Yank to clipboard" })
map("n", "<leader>Y", "\"+Y", { desc = "Yank line to clipboard" })
map("n", "<leader>p", "\"+p", { desc = "Paste from clipboard" })
-- visual P replaces the selection without overwriting the register it came from
map("x", "<leader>p", "\"+P", { desc = "Replace with clipboard" })

-- search and replace word
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word" })
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "chmod +x" })

-- exit insert mode
map("i", "jk", "<esc>")
map("i", "<esc>", "<nop>")

-- Escape clears highlighting
map("n", "<esc>", "<Cmd>nohlsearch<CR><esc>")

-- Tab Nav
map("n", "T", "gT")
map("n", "t", "gt")

-- Window nav: <C-h/j/k/l> come from vim-tmux-navigator (also crosses tmux panes)

-- Move to Top Bottom Middle
map("n", "gJ", "L", { silent = true })
map("n", "gK", "H", { silent = true })
map("n", "gM", "M", { silent = true })

--- Splitting
map("n", "<leader>v", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>-", "<Cmd>split<CR>", { desc = "Horizontal split" })

-- Tree, Undo, Outline
map("n", "<leader>t", "<Cmd>NvimTreeToggle<CR>", { desc = "File tree" })
map("n", "<leader>u", "<Cmd>UndotreeToggle<CR>", { desc = "Undo tree" })
map("n", "<leader>o", "<Cmd>AerialToggle!<CR>", { desc = "Symbol outline" })

-- Diagnostics ([d / ]d are Neovim defaults)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Buffer diagnostics to loclist" })
map("n", "<leader>Q", vim.diagnostic.setqflist, { desc = "All diagnostics to quickfix" })

-- Formatting (format-on-save is only enabled for terraform)
map({ "n", "x" }, "<leader>=", function()
  require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format buffer/selection" })

-- Find (fzf-lua). In file pickers, alt-a adds the selection to Claude.
map("n", "<leader>ff", "<Cmd>FzfLua files<CR>", { desc = "Files" })
map("n", "<leader>fg", "<Cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
map({ "n", "x" }, "<leader>fw", "<Cmd>FzfLua grep_cword<CR>", { desc = "Grep word" })
map("n", "<leader>fb", "<Cmd>FzfLua buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fo", "<Cmd>FzfLua oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fc", "<Cmd>FzfLua git_status<CR>", { desc = "Changed files (git status)" })
map("n", "<leader>fd", "<Cmd>FzfLua diagnostics_workspace<CR>", { desc = "Workspace diagnostics" })
map("n", "<leader>fs", "<Cmd>FzfLua lsp_live_workspace_symbols<CR>", { desc = "Workspace symbols" })
map("n", "<leader>fq", "<Cmd>FzfLua quickfix<CR>", { desc = "Quickfix list" })
map("n", "<leader>fh", "<Cmd>FzfLua helptags<CR>", { desc = "Help" })
map("n", "<leader>fk", "<Cmd>FzfLua keymaps<CR>", { desc = "Keymaps" })
map("n", "<leader>fr", "<Cmd>FzfLua resume<CR>", { desc = "Resume last picker" })

-- Git: review what changed (yours or an agent's)
map("n", "<leader>gd", "<Cmd>DiffviewOpen<CR>", { desc = "Diff working tree vs index" })
map("n", "<leader>gD", "<Cmd>DiffviewOpen HEAD<CR>", { desc = "Diff working tree vs HEAD" })
map("n", "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", { desc = "File history" })
map("n", "<leader>gH", "<Cmd>DiffviewFileHistory<CR>", { desc = "Repo history" })
map("n", "<leader>gq", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" })
map("n", "<leader>gs", "<Cmd>Git<CR>", { desc = "Fugitive status" })
map("n", "<leader>gl", "<Cmd>GV<CR>", { desc = "Commit log" })

--- REPL
map("n", "<leader>R", "<Cmd>ReplToggle<CR>", { desc = "Toggle REPL" })
map("n", "<leader>r", "<Plug>(ReplSendLine)", { desc = "REPL send line" })
map("x", "<leader>r", "<Plug>(ReplSendVisual)", { desc = "REPL send selection" })
map("n", "<leader>c", "<Plug>(ReplSendCell)", { desc = "REPL send cell" })
