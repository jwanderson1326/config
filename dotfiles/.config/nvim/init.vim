augroup filetype_assignment
  autocmd!
  autocmd BufRead,BufNewFile *.github/workflows/*.{yml,yaml} set filetype=yaml.github
  autocmd BufRead,BufNewFile renv.lock set filetype=json
  autocmd BufRead,BufNewFile .markdownlintrc set filetype=jsonc
  autocmd BufRead,BufNewFile *.min.js set filetype=none
  autocmd BufRead,BufNewFile *.{1p,1pm,2pm,3pm,4pm,5pm} set filetype=nroff
augroup end

augroup filetype_custom
  autocmd!
  " indentation
  autocmd Filetype c,nginx,haskell,rust,kv,asm,nasm,gdscript3 setlocal shiftwidth=4 softtabstop=4
  autocmd Filetype go,gomod,make,tsv,votl setlocal tabstop=4 softtabstop=0 shiftwidth=0 noexpandtab
  " comments
  autocmd FileType dosini setlocal commentstring=#\ %s comments=:#,:;
  autocmd FileType mermaid setlocal commentstring=\%\%\ %s comments=:\%\%
  autocmd FileType tmux,python,nginx setlocal commentstring=#\ %s comments=:# formatoptions=jcroql
  autocmd FileType jsonc setlocal commentstring=//\ %s comments=:// formatoptions=jcroql
  autocmd FileType sh setlocal formatoptions=jcroql
  autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
  " iskeyword
  autocmd FileType nginx setlocal iskeyword+=$
  autocmd FileType toml,zsh,sh,bash,css setlocal iskeyword+=-
  autocmd FileType scss setlocal iskeyword+=@-@
  " keywordprg
  autocmd FileType vim,lua setlocal keywordprg=:help
  autocmd FileType bib,gitcommit,markdown,org,plaintex,rst,rnoweb,tex,pandoc,quarto,rmd,context,html,htmldjango,xhtml,mail,text setlocal keywordprg=:DefEng
  autocmd FileType python setlocal keywordprg=:Pydoc
  autocmd FileType sh,zsh,bash setlocal keywordprg=:Man
  " nofoldenable nolist
  autocmd FileType gitcommit,checkhealth,text,GV setlocal nofoldenable nolist
  " window opening
  autocmd FileType gitcommit if winnr("$") > 1 | wincmd T | endif
  " quickfix-only
  autocmd FileType qf call s:set_quickfix_mappings()
augroup end

lua vim.loader.enable(true) -- speed up lua load times (experimental)
lua require("janderson")



command! F call s:focuswriting()
function! s:focuswriting()
  set lazyredraw
  try
    normal! ma
    let current_buffer = bufnr('%')
    tabe
    " Left Window
    let w:focuswriting = 1
    setlocal nomodifiable readonly nobuflisted nonumber norelativenumber fillchars=eob:\  colorcolumn=0 winhighlight=Normal:NormalFloat
    vsplit
    vsplit
    " Right Window
    let w:focuswriting = 1
    setlocal nomodifiable readonly nobuflisted nonumber norelativenumber fillchars=eob:\  colorcolumn=0 winhighlight=Normal:NormalFloat
    wincmd h
    " Middle Window
    let w:focuswriting = 1
    vertical resize 88
    execute 'buffer ' .. current_buffer
    setlocal number norelativenumber wrap winfixwidth colorcolumn=0 nofoldenable
    wincmd =
    normal! `azz0
  finally
    set nolazyredraw
  endtry
endfunction

command! CleanUnicode call s:clean_unicode()
function! s:clean_unicode()
  set lazyredraw
  try
    let save = winsaveview()
    silent! %substitute/”/"/g
    silent! %substitute/“/"/g
    silent! %substitute/’/'/g
    silent! %substitute/‘/'/g
    silent! %substitute/—/-/g
    silent! %substitute/…/.../g
    silent! %substitute/​//g
    silent! %substitute/–/-/g
    silent! %substitute/‐/-/g
    silent! %substitute/ / /g
    silent! %substitute/　/ /g
    silent! %substitute/′/'/g
    silent! %substitute/″/"/g
    silent! %substitute/•/*/g
    silent! %substitute/·/*/g
    silent! %substitute/°/^/g
    silent! %substitute/™/(tm)/g
    silent! %substitute/©/(c)/g
    silent! %substitute/®/(r)/g
    silent! %substitute/×/x/g
    silent! %substitute/÷/\//g
    silent! %substitute/±/+\/-/g
    silent! %substitute/½/1\/2/g
    silent! %substitute/¼/1\/4/g
    silent! %substitute/¾/3\/4/g
    silent! %substitute/‽/?!/g
    silent! %substitute/¿/?/g
    silent! %substitute/¡/!/g
    call winrestview(save)
  finally
    set nolazyredraw
  endtry
endfunction
