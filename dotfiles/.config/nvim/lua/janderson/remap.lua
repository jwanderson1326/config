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
