vim.g.mapleader = ","

vim.opt.wildmode = { "longest", "list", "full" }

vim.opt.backup = false
vim.opt.swapfile = false
-- persistent undo: reloading a file an agent rewrote stays undoable (see undotree)
vim.opt.undofile = true

vim.opt.wrap = false
vim.opt.spelllang = "en_us"
vim.opt.dictionary = "/usr/share/dict/words"
vim.opt.complete:append("k")

-- Defaults; filetype plugins and indent.lua override per language
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.softtabstop = 0 -- Disable softtabstop to prevent multi-space deletion
vim.opt.shiftwidth = 2
vim.opt.numberwidth = 4

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- also drives CursorHold (checktime for agent edits, see ai.lua)
vim.opt.updatetime = 250

vim.opt.colorcolumn = "80"

vim.opt.grepprg = "rg --vimgrep"
