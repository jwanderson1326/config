vim.api.nvim_exec([[
  augroup indentation_le
    autocmd!
    autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
    autocmd Filetype python setlocal shiftwidth=4 softtabstop=4 tabstop=8
    autocmd Filetype yaml setlocal indentkeys-=<:>
    autocmd Filetype dot :setlocal autoindent cindent
    autocmd Filetype make,tsv,votl
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
  augroup END
]], false)
