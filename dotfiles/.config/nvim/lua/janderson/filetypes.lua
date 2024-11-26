local filetype_mappings = {
  ["*.hql"] = "hive",
  ["*.q"]   = "hive",
  ["*.md"]  = "markdown",
  ["*.txt"] = "text",
  ["*.config"] = "yaml",
  ["*.jsx"] = "javascript_jsx",
  ["*.gs"] = "javascript",
  ["*.ts"] = "javascript",
  ["*.tsx"] = "javascript",
  ["*.cfg"] = "dosini",
  ["*.ini"] = "dosini",
  ["*.coveragerc"] = "dosini",
  ["*.pylintrc"] = "dosini",
  ["*.tsv"] = "tsv",
  ["Dockerfile*"] = "Dockerfile",
  ["Makefile*"] = "make",
  ["poetry.lock"] = "toml",

  -- Add more patterns and filetypes as needed
}

for pattern, ft in pairs(filetype_mappings) do
  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead", "BufEnter"}, {
    pattern = pattern,
    callback = function()
      vim.bo.filetype = ft
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    -- Buffer-local options
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 8

    -- Window-local options
    vim.wo.linebreak = true
    vim.wo.list = false
    vim.wo.wrap = true
    vim.wo.colorcolumn = "0"
    vim.wo.foldenable = false
  end,
})
