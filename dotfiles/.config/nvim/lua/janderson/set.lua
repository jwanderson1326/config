vim.opt.completeopt = { "menuone", "longest", "preview" }
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.wildmenu = true

vim.opt.hidden = true
vim.opt.compatible = false

vim.opt.mouse = "a"
vim.opt.backup = false
vim.opt.swapfile = false

vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.spelllang = "en_us"
vim.opt.dictionary = "$HOME/.american-english-with-propcase.txt"
vim.opt.complete = vim.opt.complete + "k"

-- vim.opt.tabstop = 8
-- vim.opt.softtabstop = 2
-- vim.opt.shiftwidth = 4
vim.opt.numberwidth = 4
-- vim.opt.expandtab = true

vim.opt.nu = true
vim.opt.relativenumber = true
-- vim.opt.smartindent = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.grepprg = "rg --vimgrep"

vim.g.mapleader = ","
