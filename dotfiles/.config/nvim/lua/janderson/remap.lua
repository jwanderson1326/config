vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

-- center screen while moving fast
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "n", "nzzzv")

-- copy paste without losing original
vim.keymap.set("x", "<leader>p", "\"_dP")

-- copy paste to outside
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- search and replace word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- exit insert mode
vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "<esc>", "<nop>")

-- Escape clears highlighting
vim.keymap.set("n", "<esc>", ":noh<return><esc>", { silent = true })

-- Tab Nav
vim.keymap.set("n", "T", "gT")
vim.keymap.set("n", "t", "gj")

-- Buffer Nav
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true })

-- Move to Top Bottom Middle
vim.keymap.set("n", "gJ", "L", { silent = true })
vim.keymap.set("n", "gK", "H", { silent = true })
vim.keymap.set("n", "gM", "M", { silent = true })

--- Splitting
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
vim.keymap.set("n", "<leader>h", ":hsplit<CR>")

-- Tree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

-- Aerial
vim.keymap.set("n", "<leader>a", ":AerialToggle!<CR>")

-- Diagnostics
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map("n", "<leader>e", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<leader>q", vim.diagnostic.setloclist, opts)

--- Nav
vim.keymap.set("n", "<leader>R", ":ReplToggle<CR>")
vim.keymap.set("n", "<leader>r", "<Plug>(ReplSendLine)")
vim.keymap.set("x", "<leader>r", "<Plug>(ReplSendVisual)")
vim.keymap.set("n", "<leader>c", "<Plug>(ReplSendCell)")

-- Aider integration
vim.keymap.set("n", "<leader>ao", "<cmd>ReplAider<CR>", { silent = true })
vim.keymap.set("n", "<leader>aa", "<cmd>ReplAiderBufCur /add<CR>", { silent = true })
vim.keymap.set("n", "<leader>ad", "<cmd>ReplAiderBufCur /drop<CR>", { silent = true })
vim.keymap.set("n", "<leader>as", "<cmd>ReplSend<CR>", { silent = true })
