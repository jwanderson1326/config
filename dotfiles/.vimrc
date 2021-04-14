g" Notes:
"   * When in normal mode, scroll over a folded section and type 'za'
"       this toggles the folded section
"
" Initialization:
"   1. At the command line, execute the following command:
"     curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"   2. Open vim (hint: type vim at command line and press enter :p)
"   3. :PlugInstall
"   4. :PlugUpdate
"   5. You should be ready for MVP editing
"
" Updating:
"   If you want to upgrade your vim plugins to latest version
"     :PlugUpdate
"   If you want to upgrade vim-plug itself
"     :PlugUpgrade
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

call plug#begin('~/.vim/plugged')

" Help for vim-plug
Plug 'junegunn/vim-plug'

" Commands run in vim's virtual screen and don't pollute main shell
Plug 'fcpg/vim-altscreen'

"" Basic coloring
Plug 'NLKNguyen/papercolor-theme'
Plug 'ryanoasis/vim-devicons'

"Lightline
Plug 'itchyny/lightline.vim'

"" Utils
Plug 'kh3phr3n/tabline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'dkarter/bullets.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Shougo/defx.nvim'
Plug 'kristijanhusak/defx-git'
Plug 'kristijanhusak/defx-icons'

"" Language-specific syntax
Plug 'hdima/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'hashivim/vim-terraform'
Plug 'khalliday7/Jenkinsfile-vim-syntax'
Plug 'ekalinin/Dockerfile.vim'
Plug 'othree/html5.vim'
Plug 'mxw/vim-jsx'

" Indentation
Plug 'hynek/vim-python-pep8-indent'
Plug 'vim-scripts/groovyindent-unix'

"" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
for coc_plugin in [
      \ 'git@github.com:fannheyward/coc-markdownlint.git',
      \ 'git@github.com:josa42/coc-docker.git',
      \ 'git@github.com:neoclide/coc-css.git',
      \ 'git@github.com:neoclide/coc-pairs.git',
      \ 'git@github.com:neoclide/coc-html.git',
      \ 'git@github.com:neoclide/coc-json.git',
      \ 'git@github.com:neoclide/coc-python.git',
      \ 'git@github.com:neoclide/coc-rls.git',
      \ 'git@github.com:neoclide/coc-snippets.git',
      \ 'git@github.com:neoclide/coc-tsserver.git',
      \ 'git@github.com:neoclide/coc-yaml.git',
      \ 'git@github.com:pappasam/coc-jedi.git',
      \ 'git@github.com:iamcco/coc-diagnostic.git',
      \ 'git@github.com:iamcco/coc-spell-checker.git',
      \ 'git@github.com:iamcco/coc-vimlsp.git',
      \ ]
  Plug coc_plugin, {'do': 'yarn install --frozen-lockfile && yarn build'}
endfor

"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

call plug#end()

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
        \ setlocal shiftwidth=4 softtabstop=4 tabstop=8
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
        \ setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8 wrap linebreak nolist colorcolumn=0 nofoldenable
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
let g:markdown_composer_open_browser = 0

" Package: defx

" TogglePluginWindows:
nnoremap <silent> <space>j <cmd>Defx
      \ -buffer-name=defx
      \ -columns=mark:indent:icons:filename:git:type
      \ -direction=topleft
      \ -search=`expand('%:p')`
      \ -session-file=`g:custom_defx_state`
      \ -ignored-files=`g:defx_ignored_files`
      \ -split=vertical
      \ -toggle
      \ -floating-preview
      \ -vertical-preview
      \ -preview-height=50
      \ -winwidth=31
      \ -root-marker=''
      \ <CR>
nnoremap <silent> <space>J <cmd>Defx `expand('%:p:h')`
      \ -buffer-name=defx
      \ -columns=mark:indent:icons:filename:git:type
      \ -direction=topleft
      \ -search=`expand('%:p')`
      \ -ignored-files=`g:defx_ignored_files`
      \ -show-ignored-files
      \ -split=vertical
      \ -floating-preview
      \ -vertical-preview
      \ -preview-height=50
      \ -winwidth=31
      \ -root-marker=''
      \ <CR>

" Override <C-w>H to delete defx buffers
nnoremap <C-w>H <cmd>windo if &filetype == 'defx' <bar> close <bar> endif<CR><C-w>H

let g:custom_defx_state = tempname()

let g:defx_ignored_files = join([
      \ '*.aux',
      \ '*.egg-info/',
      \ '*.o',
      \ '*.out',
      \ '*.pdf',
      \ '*.pyc',
      \ '*.toc',
      \ '.*',
      \ '__pycache__/',
      \ 'build/',
      \ 'dist/',
      \ 'docs/_build/',
      \ 'fonts/',
      \ 'node_modules/',
      \ 'pip-wheel-metadata/',
      \ 'plantuml-images/',
      \ 'site/',
      \ 'target/',
      \ 'venv.bak/',
      \ 'venv/',
      \ ], ',')

let g:custom_defx_mappings = [
      \ ['!             ', "defx#do_action('execute_command')"],
      \ ['*             ', "defx#do_action('toggle_select_all')"],
      \ [';             ', "defx#do_action('repeat')"],
      \ ['<2-LeftMouse> ', "defx#is_directory() ? defx#do_action('open_tree', 'toggle') : defx#do_action('drop')"],
      \ ['<C-g>         ', "defx#do_action('print')"],
      \ ['<C-R>         ', "defx#do_action('resize', 31)"],
      \ ['<C-i>         ', "defx#do_action('open_directory')"],
      \ ['<C-o>         ', "defx#do_action('cd', ['..'])"],
      \ ['<C-r>         ', "defx#do_action('redraw')"],
      \ ['<C-t>         ', "defx#do_action('open', 'tabe')"],
      \ ['<C-v>         ', "defx#do_action('open', 'vsplit')"],
      \ ['<C-x>         ', "defx#do_action('drop', 'split')"],
      \ ['<CR>          ', "defx#do_action('drop')"],
      \ ['<RightMouse>  ', "defx#do_action('cd', ['..'])"],
      \ ['O             ', "defx#do_action('open_tree', 'recursive:3')"],
      \ ['p             ', "defx#do_action('preview')"],
      \ ['a             ', "defx#do_action('toggle_select')"],
      \ ['cc            ', "defx#do_action('copy')"],
      \ ['cd            ', "defx#do_action('change_vim_cwd')"],
      \ ['i             ', "defx#do_action('toggle_ignored_files')"],
      \ ['ma            ', "defx#do_action('new_file')"],
      \ ['md            ', "defx#do_action('remove')"],
      \ ['mm            ', "defx#do_action('rename')"],
      \ ['o             ', "defx#is_directory() ? defx#do_action('open_tree', 'toggle') : defx#do_action('drop')"],
      \ ['P             ', "defx#do_action('paste')"],
      \ ['q             ', "defx#do_action('quit')"],
      \ ['ss            ', "defx#do_action('multi', [['toggle_sort', 'TIME'], 'redraw'])"],
      \ ['t             ', "defx#do_action('open_tree', 'toggle')"],
      \ ['u             ', "defx#do_action('cd', ['..'])"],
      \ ['x             ', "defx#do_action('execute_system')"],
      \ ['yy            ', "defx#do_action('yank_path')"],
      \ ['~             ', "defx#do_action('cd')"],
      \ ]

function! s:autocmd_custom_defx()
  if !exists('g:loaded_defx')
    return
  endif
  call defx#custom#column('filename', {
        \ 'min_width': 100,
        \ 'max_width': 100,
        \ })
endfunction

function! s:open_defx_if_directory()
  if !exists('g:loaded_defx')
    echom 'Defx not installed, skipping...'
    return
  endif
  if isdirectory(expand(expand('%:p')))
    Defx `expand('%:p')`
        \ -buffer-name=defx
        \ -columns=mark:git:indent:icons:filename:type:size:time
  endif
endfunction

function! s:defx_redraw()
  if !exists('g:loaded_defx')
    return
  endif
  call defx#redraw()
endfunction

function! s:defx_buffer_remappings() abort
  " Define mappings
  for [key, value] in g:custom_defx_mappings
    execute 'nnoremap <silent><buffer><expr> ' . key . ' ' . value
  endfor
  nnoremap <silent><buffer> ?
        \ :for [key, value] in g:custom_defx_mappings <BAR>
        \ echo '' . key . ': ' . value <BAR>
        \ endfor<CR>
endfunction

augroup custom_defx
  autocmd!
  autocmd VimEnter * call s:autocmd_custom_defx()
  autocmd BufEnter * call s:open_defx_if_directory()
  autocmd BufLeave,BufWinLeave \[defx\]* silent call defx#call_action('add_session')
  autocmd FileType defx setlocal nonumber norelativenumber
augroup end

augroup custom_remap_defx
  autocmd!
  autocmd FileType defx call s:defx_buffer_remappings()
  autocmd FileType defx nmap     <buffer> <silent> gp <Plug>(defx-git-prev)
  autocmd FileType defx nmap     <buffer> <silent> gn <Plug>(defx-git-next)
  autocmd FileType defx nmap     <buffer> <silent> gs <Plug>(defx-git-stage)
  autocmd FileType defx nmap     <buffer> <silent> gu <Plug>(defx-git-reset)
  autocmd FileType defx nmap     <buffer> <silent> gd <Plug>(defx-git-discard)
augroup end


" Better Whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

" }}}
" COC Configs ---------------------- {{{
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

"  }}}
" terraform Syntax {{{
let g:terraform_align = 1

let g:terraform_fold_sections = 0

let g:terraform_fmt_on_save = 1

let g:terraform_remap_spacebar = 1

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
