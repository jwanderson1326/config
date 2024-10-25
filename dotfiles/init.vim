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
set termguicolors

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
call plug#begin()
" List your plugins here
Plug 'kristijanhusak/vim-packager', {'type': 'opt'}

  " Autocompletion And IDE Features:
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

  " TreeSitter:
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lewis6991/spellsitter.nvim'
Plug 'nvim-treesitter/playground'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/nvim-treesitter-context'

  " Editorconfig:
Plug 'gpanders/editorconfig.nvim'

  " Tree:
Plug 'kyazdani42/nvim-tree.lua', {'requires': [
      \ 'kyazdani42/nvim-web-devicons',
      \ ]}

  " General:
Plug 'bronson/vim-visual-star-search'
Plug 'fidian/hexmode'
Plug 'simeji/winresizer'
Plug 'sjl/strftimedammit.vim'
Plug 'unblevable/quick-scope'
Plug 'windwp/nvim-autopairs'
Plug 'ntpeters/vim-better-whitespace'
Plug 'NvChad/nvim-colorizer.lua'
Plug 'tpope/vim-characterize'

  " KeywordPrg:
Plug 'pappasam/vim-keywordprg-commands'

  " Fuzzy Finder:
Plug 'nvim-telescope/telescope.nvim', {'requires': [
      \ 'nvim-lua/plenary.nvim',
      \ ]}

  " Git:
Plug 'lewis6991/gitsigns.nvim'

  " Text Objects:
Plug 'machakann/vim-sandwich'
Plug 'kana/vim-textobj-user'

  " Writing:
Plug 'dkarter/bullets.vim'
Plug 'jlesquembre/rst-tables.nvim'

  " Previewers:
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install'}

  " Code Formatters:
Plug 'pappasam/vim-filetype-formatter'

  " Repl Integration:
Plug 'pappasam/nvim-repl', {'requires': [
        \ 'tpope/vim-repeat',
        \ ]}

  " Syntax Theme:
Plug 'folke/tokyonight.nvim'
Plug 'itchyny/lightline.vim'
Plug 'rebelot/kanagawa.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ryanoasis/vim-devicons'

  " Syntax Highlighting & Indentation:
Plug 'evanleck/vim-svelte', {'requires': [
      \ 'cakebaker/scss-syntax.vim',
      \ 'groenewege/vim-less',
      \ 'leafgarland/typescript-vim',
      \ 'othree/html5.vim',
      \ 'pangloss/vim-javascript',
      \ ]}
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'Yggdroot/indentLine'
Plug 'aklt/plantuml-syntax'
Plug 'chr4/nginx.vim'
Plug 'delphinus/vim-firestore'
Plug 'mattn/vim-xxdcursor'
Plug 'neovimhaskell/haskell-vim'
Plug 'raimon49/requirements.txt.vim'
Plug 'hashivim/vim-terraform'
Plug 'elzr/vim-json'
Plug 'ekalinin/Dockerfile.vim'

Plug 'github/copilot.vim'
call plug#end()
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
  call s:safe_require('config.nvim-ts-context-commentstring')
  call s:safe_require('config.spellsitter')
  call s:safe_require('config.treesitter-context')
  call s:safe_require('config.tokyonight')
  call s:safe_require('config.nightfox')
endfunction

call s:setup_lua_packages()

" Tree Sitter (highlighting) {{{

function! HandleVimEnter()
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'python',
    'terraform',
    'javascript',
    'typescript',
    'tsx',
    'html',
    'css',
    'json',
    'yaml',
    'toml',
    'bash',
  },
  highlight = {
    enable = true,
    disable = {},
  },
}
EOF
endfunction
augroup vimenter
  autocmd! VimEnter * call HandleVimEnter()
augroup END
" }}}

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


" VimJavascript:
let g:javascript_plugin_flow = 1

" Syntax: select global syntax scheme
" Make sure this is at end of section
try
  colorscheme nightfox
catch
  echo 'an error occured with colorscheme'
endtry

" }}}
"  Plugin: Configure ------------ {{{

" Python highlighting
let python_highlight_all = 1

"Lightline
let g:lightline = {
      \ 'colorscheme': 'nightfox',
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
  augroup focuswriting
    autocmd!
  augroup end
  let current_buffer = bufnr('%')
  tabe
  try
    file focuswriting_abcdefg
  catch
    edit focuswriting_abcdefg
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
  call s:focuswriting_settings_middle()
  wincmd =
  augroup focuswriting
    autocmd!
    autocmd WinEnter focuswriting_abcdefg call s:focuswriting_autocmd()
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

function! s:focuswriting_autocmd()
  for windowid in range(1, winnr('$'))
    if bufname(winbufnr(windowid)) != 'focuswriting_abcdefg'
      execute windowid .. 'wincmd w'
      return
    endif
  endfor
  if tabpagenr('$') > 1
    tabclose
  else
    wqall
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

  " Spliting
  nnoremap <leader>v :vsplit<CR>
  nnoremap <leader>h :split<CR>

  vnoremap <C-t> :'<,'>!tr -d '"{$}'<CR>

  nnoremap <leader>t :NvimTreeToggle<CR>
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

