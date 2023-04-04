" Usage: toggle fold in Vim with 'za'. 'zR' to open all folds, 'zM' to close
" General: Leader mappings -------------------- {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" General: global config ------------ {{{
set completeopt=menuone,longest,preview
set wildmode=longest,list,full
set wildmenu

" " Enable buffer deletion instead of having to write each buffer
set hidden

" Mouse: mouse support
set mouse=a

" SwapFiles: prevent their creation
set nobackup
set noswapfile

" Do not wrap lines by default
set nowrap

" Set column to light grey at 80 characters
"if (exists('+colorcolumn'))
"  set colorcolumn=80
"  highlight ColorColumn ctermbg=9
"endif

" Highlight Search:
set incsearch
augroup sroeca_incsearch_highlight
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
augroup END

filetype plugin indent on

augroup cursorline_setting
  autocmd!
  autocmd WinEnter,BufEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

set spelllang=en_us
set dictionary=$HOME/.american-english-with-propcase.txt
set complete+=k

set showtabline=2
set nojoinspaces
set autoread

" Grep: program is 'rg'
set grepprg=rg\ --vimgrep


" Pasting: enable pasting without having to do 'set paste'
" NOTE: this is actually typed <C-/>, but vim thinks this is <C-_>
set pastetoggle=<C-_>

" Turn off complete vi compatibility
set nocompatible

" Enable using local vimrc
set exrc

" Numbers
set number relativenumber
set numberwidth=4

" Lightline: specifics for Lightline
set laststatus=2
set ttimeoutlen=50
set noshowmode


" }}}
" General: Plugin Install --------------------- {{{

" Automatically install nvim-packager
call system([
      \ 'git',
      \ 'clone',
      \ 'https://github.com/kristijanhusak/vim-packager',
      \ $HOME . '/.config/nvim/pack/packager/opt/vim-packager'])

" Available Commands:
"   PackagerStatus, PackagerInstall, PackagerUpdate, PackagerClean

function! s:packager_init(packager) abort
  call a:packager.add('https://github.com/kristijanhusak/vim-packager', {'type': 'opt'})

  " Autocompletion And IDE Features:
  call a:packager.add('https://github.com/neoclide/coc.nvim.git', {'do': 'yarn install --frozen-lockfile'})

  " TreeSitter:
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter.git', {'do': ':TSUpdate'})
  call a:packager.add('https://github.com/lewis6991/spellsitter.nvim.git')
  call a:packager.add('https://github.com/nvim-treesitter/playground.git')
  call a:packager.add('https://github.com/windwp/nvim-ts-autotag.git')
  call a:packager.add('https://github.com/nvim-treesitter/nvim-treesitter-context')
  call a:packager.add('https://github.com/JoosepAlviste/nvim-ts-context-commentstring.git', {'requires': [
      \ 'https://github.com/tpope/vim-commentary',
      \ ]})

  " Editorconfig:
  call a:packager.add('https://github.com/gpanders/editorconfig.nvim.git')

  " Tree:
  call a:packager.add('https://github.com/kyazdani42/nvim-tree.lua.git', {'requires': [
      \ 'https://github.com/kyazdani42/nvim-web-devicons.git',
      \ ]})

  " General:
  call a:packager.add('https://github.com/bronson/vim-visual-star-search')
  call a:packager.add('https://github.com/fidian/hexmode')
  call a:packager.add('https://github.com/simeji/winresizer')
  call a:packager.add('https://github.com/sjl/strftimedammit.vim')
  call a:packager.add('https://github.com/unblevable/quick-scope')
  call a:packager.add('https://github.com/windwp/nvim-autopairs.git')
  call a:packager.add('https://github.com/ntpeters/vim-better-whitespace.git')
  call a:packager.add('https://github.com/NvChad/nvim-colorizer.lua')
  call a:packager.add('https://github.com/tpope/vim-characterize.git')

  " KeywordPrg:
  call a:packager.add('https://github.com/pappasam/vim-keywordprg-commands.git')

  " Fuzzy Finder:
  call a:packager.add('https://github.com/nvim-telescope/telescope.nvim.git', {'requires': [
      \ 'https://github.com/nvim-lua/plenary.nvim.git',
      \ ]})

  " Git:
  call a:packager.add('https://github.com/tpope/vim-fugitive')
  call a:packager.add('https://github.com/rhysd/git-messenger.vim.git')
  call a:packager.add('https://github.com/lewis6991/gitsigns.nvim.git')

  " Text Objects:
  call a:packager.add('https://github.com/machakann/vim-sandwich')
  call a:packager.add('https://github.com/kana/vim-textobj-user')

  " Writing:
  call a:packager.add('https://github.com/dkarter/bullets.vim')
  call a:packager.add('https://github.com/jlesquembre/rst-tables.nvim')
  call a:packager.add('https://github.com/moiatgit/vim-rst-sections')

  " Previewers:
  call a:packager.add('https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'})

  " Code Formatters:
  call a:packager.add('https://github.com/pappasam/vim-filetype-formatter')

  " Repl Integration:
  call a:packager.add('https://github.com/pappasam/nvim-repl.git', {'requires': [
        \ 'https://github.com/tpope/vim-repeat',
        \ ]})

  " Syntax Theme:
  call a:packager.add('https://github.com/NLKNguyen/papercolor-theme')
  call a:packager.add('https://github.com/ryanoasis/vim-devicons')
  call a:packager.add('https://github.com/itchyny/lightline')

  " Syntax Highlighting & Indentation:
  call a:packager.add('https://github.com/evanleck/vim-svelte.git', {'requires': [
      \ 'https://github.com/cakebaker/scss-syntax.vim.git',
      \ 'https://github.com/groenewege/vim-less.git',
      \ 'https://github.com/leafgarland/typescript-vim.git',
      \ 'https://github.com/othree/html5.vim.git',
      \ 'https://github.com/pangloss/vim-javascript.git',
      \ ]})
  call a:packager.add('https://github.com/Vimjas/vim-python-pep8-indent')
  call a:packager.add('https://github.com/Yggdroot/indentLine')
  call a:packager.add('https://github.com/aklt/plantuml-syntax.git')
  call a:packager.add('https://github.com/chr4/nginx.vim.git')
  call a:packager.add('https://github.com/delphinus/vim-firestore.git')
  call a:packager.add('https://github.com/mattn/vim-xxdcursor')
  call a:packager.add('https://github.com/neovimhaskell/haskell-vim')
  call a:packager.add('https://github.com/raimon49/requirements.txt.vim.git')
  call a:packager.add('https://github.com/hashivim/vim-terraform')
  call a:packager.add('https://github.com/elzr/vim-json')
  call a:packager.add('https://github.com/ekalinin/Dockerfile.vim')
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'), {
      \ 'window_cmd': 'edit',
      \ })
" }}}
" Package: lua extensions {{{

function! s:safe_require(package)
  try
    execute "lua require('" . a:package . "')"
  catch
    echom "Error with lua require('" . a:package . "')"
  endtry
endfunction

function! s:setup_lua_packages()
  call s:safe_require('config.colorizer')
  call s:safe_require('config.gitsigns')
  call s:safe_require('config.nvim-autopairs')
  call s:safe_require('config.nvim-tree')
  call s:safe_require('config.nvim-treesitter')
  call s:safe_require('config.nvim-ts-context-commentstring')
  call s:safe_require('config.nvim-web-devicons')
  call s:safe_require('config.spellsitter')
  call s:safe_require('config.telescope')
  call s:safe_require('config.treesitter-context')
endfunction

call s:setup_lua_packages()

augroup general_lua_extensions
  autocmd!
  autocmd FileType vim let &l:path .= ','.stdpath('config').'/lua'
  autocmd FileType vim setlocal
        \ includeexpr=substitute(v:fname,'\\.','/','g')
        \ suffixesadd^=.lua
augroup end

command! GitsignsToggle Gitsigns toggle_signs
" }}}
" General: Filetype specification ------------ {{{

augroup filetype_recognition
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter *.hql,*.q set filetype=hive
  autocmd BufNewFile,BufRead,BufEnter *.config set filetype=yaml
  autocmd BufNewFile,BufRead,BufEnter *.bowerrc,*.babelrc,*.eslintrc,*.slack-term
        \ set filetype=json
  autocmd BufNewFile,BufRead,BufEnter *.asm set filetype=nasm
  autocmd BufNewFile,BufRead,BufEnter *.handlebars set filetype=html
  autocmd BufNewFile,BufRead,BufEnter *.m,*.oct set filetype=octave
  autocmd BufNewFile,BufRead,BufEnter *.jsx set filetype=javascript.jsx
  autocmd BufNewFile,BufRead,BufEnter *.gs,*.ts,*.tsx set filetype=javascript
  autocmd BufNewFile,BufRead,BufEnter *.cfg,*.ini,.coveragerc,.pylintrc
        \ set filetype=dosini
  autocmd BufNewFile,BufRead,BufEnter *.tsv set filetype=tsv
  autocmd BufNewFile,BufRead,BufEnter Dockerfile* set filetype=Dockerfile
  autocmd BufNewFile,BufRead,BufEnter Makefile* set filetype=make
  autocmd BufNewFile,BufRead,BufEnter poetry.lock set filetype=toml
augroup END

augroup filetype_vim
  autocmd!
  autocmd BufWritePost *vimrc so $MYVIMRC |
        \if has('gui_running') |
        \so $MYVIMRC |
        \endif
augroup END

" }}}
" General: Indentation (tabs, spaces, width, etc)------------- {{{
augroup indentation_sr
  autocmd!
  autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
  autocmd Filetype python,c,elm,haskell,rust,rst,kv,nginx,asm,nasm
        \ setlocal shiftwidth=4 softtabstop=4 tabstop=4
  autocmd Filetype dot setlocal autoindent cindent
  autocmd Filetype make,tsv,votl,go
        \ setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab
  " Prevent auto-indenting from occuring
  autocmd Filetype yaml setlocal indentkeys-=<:>

  autocmd Filetype ron setlocal cindent
        \ cinkeys=0{,0},0(,0),0[,0],:,0#,!^F,o,O,e
        \ cinoptions+='(s,m2'
        \ cinoptions+='(s,U1'
        \ cinoptions+='j1'
        \ cinoptions+='J1'
augroup END

" }}}
" General: Wrapping text -------------------------------------- {{{
augroup writing
  autocmd!
  autocmd FileType markdown,gitcommit
        \ setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8 linebreak nolist wrap colorcolumn=0 nofoldenable
  autocmd BufNewFile,BufRead *.html,*.txt,*.tex :setlocal wrap linebreak nolist
augroup END
" }}}
" General: Folding Settings --------------- {{{

augroup fold_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType * setlocal foldnestmax=1
augroup END

" }}}
" General: Syntax highlighting ---------------- {{{

" Papercolor: options
let g:PaperColor_Theme_Options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     }
  \   }
  \ }

" Python: Highlight self and cls keyword in class definitions
augroup python_syntax
  autocmd!
  autocmd FileType python syn keyword pythonBuiltinObj self
  autocmd FileType python syn keyword pythonBuiltinObj cls
augroup end

" VimJavascript:
let g:javascript_plugin_flow = 1

" Syntax: select global syntax scheme
" Make sure this is at end of section
try
  colorscheme PaperColor
catch
endtry

" }}}
"  Plugin: Configure ------------ {{{

" Python highlighting
let python_highlight_all = 1

"Lightline
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'filename', 'gitbranch', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

"Bullets
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]


"" Markdown Viewer
let g:mkdp_auto_start = 0


" Better Whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

" }}}
" COC Configs ---------------------- {{{
" TextEdit might fail if hidden is not set.
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'
let g:coc_start_at_startup = 1
let g:coc_filetype_map = {
      \ 'markdown.mdx': 'markdown',
      \ 'yaml.ansible': 'yaml',
      \ 'yaml.docker-compose': 'yaml',
      \ 'jinja.html': 'html',
      \ }

" Coc Global Extensions: automatically installed on Vim open
let g:coc_global_extensions = [
      \ '@yaegassy/coc-marksman',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-dictionary',
      \ 'coc-docker',
      \ 'coc-emoji',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-kotlin',
      \ 'coc-lists',
      \ 'coc-ltex',
      \ 'coc-pairs',
      \ 'coc-markdownlint',
      \ 'coc-prisma',
      \ 'coc-pyright',
      \ 'coc-r-lsp',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-sumneko-lua',
      \ 'coc-svg',
      \ 'coc-syntax',
      \ 'coc-texlab',
      \ 'coc-toml',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-word',
      \ 'coc-yank',
      \ 'coc-yaml',
      \ ]

"  }}}
" terraform Syntax {{{
let g:terraform_align = 1

let g:terraform_fold_sections = 0

let g:terraform_fmt_on_save = 1

let g:terraform_remap_spacebar = 1

" }}}
" General: focus writing {{{

function! s:focuswriting()
  if exists('w:custom_focus_writing')
    call s:focuswriting_close()
    call s:focuswriting_clean()
    return
  endif
  let current_buffer = bufnr('%')
  if exists('g:custom_focus_writing')
    let success = win_gotoid(g:custom_focus_writing)
    if (success)
      execute 'buffer ' . current_buffer
      call s:focuswriting_settings_middle()
      return
    else
      call s:focuswriting_clean()
    endif
  endif
  tabe
  try
    file customfocuswriting
  catch
    edit customfocuswriting
  endtry
  setlocal nobuflisted
  " Left Window
  call s:focuswriting_settings_side()
  vsplit
  vsplit
  " Right Window
  call s:focuswriting_settings_side()
  wincmd h
  " Middle Window
  vertical resize 88
  execute 'buffer ' . current_buffer
  let w:custom_focus_writing = 1
  call s:focuswriting_settings_middle()
  let g:custom_focus_writing = win_getid()
  wincmd =
  augroup custom_focus_writing
    autocmd!
    autocmd WinEnter customfocuswriting call s:focuswriting_autocmd()
  augroup end
endfunction

function! s:focuswriting_settings_side()
  setlocal nonumber norelativenumber nocursorline
        \ fillchars=vert:\ ,eob:\  statusline=\  colorcolumn=0
        \ winhighlight=Normal:NormalFloat
endfunction

function! s:focuswriting_settings_middle()
  " Note: stlnc uses <C-k>NS to enter a space character in statusline
  setlocal number norelativenumber wrap nocursorline winfixwidth
        \ fillchars=vert:\ ,eob:\ ,stlnc:  statusline=\  colorcolumn=0
        \ nofoldenable winhighlight=StatusLine:StatusLineNC
endfunction

function! s:focuswriting_clean()
  augroup custom_focus_writing
    autocmd!
  augroup end
  augroup! custom_focus_writing
  unlet g:custom_focus_writing
endfunction

function! s:focuswriting_close()
  if tabpagenr('$') == 1
    wqall
  else
    tabclose
  endif
endfunction

function! s:focuswriting_autocmd()
  wincmd p
  if bufname('%') == 'customfocuswriting'
    call s:focuswriting_close()
    call s:focuswriting_clean()
  else
    wincmd =
  endif
endfunction

command! FocusWriting call s:focuswriting()

" }}}
" General: Key remappings {{{

function! GlobalKeyMappings()
  " Put your key remappings here
  " Prefer nnoremap to nmap, inoremap to imap, and vnoremap to vmap
  " This is defined as a function to allow me to reset all my key remappings
  " without needing to repeate myself.

  " MoveVisual: up and down visually only if count is specified before
  " Otherwise, you want to move up lines numerically e.g. ignore wrapped lines
  nnoremap <expr> k
        \ v:count == 0 ? 'gk' : 'k'
  vnoremap <expr> k
        \ v:count == 0 ? 'gk' : 'k'
  nnoremap <expr> j
        \ v:count == 0 ? 'gj' : 'j'
  vnoremap <expr> j
        \ v:count == 0 ? 'gj' : 'j'

  " Escape: also clears highlighting
  nnoremap <silent> <esc> :noh<return><esc>

  " J: basically, unmap in normal mode unless range explicitly specified
  nnoremap <silent> <expr> J v:count == 0 ? '<esc>' : 'J'

  " moving forward and backward with vim tabs
  nnoremap T gT
  nnoremap t gt

  " BuffersAndWindows:
  " Move from one window to another
  nnoremap <silent> <C-k> :wincmd k<CR>
  nnoremap <silent> <C-j> :wincmd j<CR>
  nnoremap <silent> <C-l> :wincmd l<CR>
  nnoremap <silent> <C-h> :wincmd h<CR>
  " Move cursor to top, bottom, and middle of screen
  nnoremap <silent> gJ L
  nnoremap <silent> gK H
  nnoremap <silent> gM M
  " Escape insert mode
  inoremap jk <esc>
  inoremap <esc> <nop>

  vnoremap <leader>y "+y
  nnoremap <leader>y "+y
  vnoremap <leader>p "+p
  nnoremap <leader>p "+p

  vnoremap <C-t> :'<,'>!tr -d '"{$}'<CR>
endfunction

call GlobalKeyMappings()

" }}}
" General: Command abbreviations ------------------------ {{{

" Abbreviations:
iabbrev waht what
iabbrev tehn then
iabbrev adn and
iabbrev tfr resource
iabbrev mnw module.network.


" fix misspelling of ls
cabbrev LS ls
cabbrev lS ls
cabbrev Ls ls

" fix misspelling of vs and sp
cabbrev SP sp
cabbrev sP sp
cabbrev Sp sp
cabbrev VS vs
cabbrev vS vs
cabbrev Vs vs

" }}}
" General: Cleanup ------------------ {{{
" commands that need to run at the end of my vimrc

" disable unsafe commands in your project-specific .vimrc files
" This will prevent :autocmd, shell and write commands from being
" run inside project-specific .vimrc files unless they’re owned by you.
set secure

" }}}

