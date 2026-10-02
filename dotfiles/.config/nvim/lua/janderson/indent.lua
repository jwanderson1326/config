-- Global defaults live in set.lua. Neovim's ftplugins already apply the
-- recommended style for go, python, rust and make; only deviations go here.
local group = vim.api.nvim_create_augroup("indentation", { clear = true })

local function filetype(pattern, callback)
  vim.api.nvim_create_autocmd("FileType", { group = group, pattern = pattern, callback = callback })
end

filetype({ "c", "cpp", "nginx", "haskell", "asm", "nasm" }, function()
  vim.opt_local.shiftwidth = 4
end)
filetype({ "go", "gomod", "tsv" }, function()
  vim.opt_local.expandtab = false
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 0
end)
filetype("make", function()
  vim.opt_local.tabstop = 4
end)
filetype("yaml", function()
  vim.opt_local.indentkeys:remove("<:>")
end)
filetype("dot", function()
  vim.opt_local.autoindent = true
  vim.opt_local.cindent = true
end)
