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
  " indentation: see lua/janderson/indent.lua
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
  autocmd FileType sh,zsh,bash setlocal keywordprg=:Man
  " nofoldenable nolist
  autocmd FileType gitcommit,checkhealth,text,GV setlocal nofoldenable nolist
  " window opening
  autocmd FileType gitcommit if winnr("$") > 1 | wincmd T | endif
augroup end

lua vim.loader.enable() -- cache compiled lua modules
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

" Normalize typographic unicode (common in LLM and web output) to ASCII.
" Whole buffer by default, or a range: :'<,'>CleanUnicode
command! -range=% CleanUnicode call s:clean_unicode(<line1>, <line2>)
function! s:clean_unicode(line1, line2) abort
  let l:replacements = [
        \ ['\%u201c', '"'], ['\%u201d', '"'], ['\%u2033', '"'],
        \ ['\%u2018', "'"], ['\%u2019', "'"], ['\%u2032', "'"],
        \ ['\%u2014', '-'], ['\%u2013', '-'], ['\%u2010', '-'], ['\%u2011', '-'], ['\%u2212', '-'],
        \ ['\%u2026', '...'],
        \ ['\%u200b', ''], ['\%ufeff', ''],
        \ ['\%u00a0', ' '], ['\%u202f', ' '], ['\%u3000', ' '],
        \ ['\%u2022', '*'], ['\%u00b7', '*'],
        \ ['\%u00b0', '^'],
        \ ['\%u2122', '(tm)'], ['\%u00a9', '(c)'], ['\%u00ae', '(r)'],
        \ ['\%u00d7', 'x'], ['\%u00f7', '/'], ['\%u00b1', '+/-'],
        \ ['\%u00bd', '1/2'], ['\%u00bc', '1/4'], ['\%u00be', '3/4'],
        \ ['\%u203d', '?!'], ['\%u00bf', '?'], ['\%u00a1', '!'],
        \ ]
  let l:save = winsaveview()
  for [l:from, l:to] in l:replacements
    execute 'keeppatterns silent' a:line1 .. ',' .. a:line2 .. 'substitute/' .. l:from .. '/' .. escape(l:to, '/\&~') .. '/ge'
  endfor
  call winrestview(l:save)
endfunction
