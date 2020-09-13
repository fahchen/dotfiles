" Vim 8 defaults
unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

let s:darwin = has('mac')

" ============================================================================
" VIM-PLUG BLOCK {{{
" ============================================================================

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Code
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/rainbow_parentheses.vim'

" Colors
Plug 'arcticicestudio/nord-vim'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Edit
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'https://github.com/garbas/vim-snipmate'
Plug 'honza/vim-snippets'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Git
Plug 'mhinz/vim-signify'

" Lang
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'slim-template/vim-slim', { 'for': 'slim' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'honza/dockerfile.vim', { 'for': 'dockerfile' }
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'elixir-editors/vim-elixir', { 'for': 'elixir' }
Plug 'mhinz/vim-mix-format', { 'for': 'elixir' }
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'jparise/vim-graphql', { 'for': 'graphql' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

" Elixir
let g:mix_format_silent_errors = 0
let g:mix_format_on_save = 1

" Rust
let g:rustfmt_autosave = 1

" Lint
Plug 'dense-analysis/ale'

" Initialize plugin system
call plug#end()

" ============================================================================
" BASIC SETTINGS
" ============================================================================

let mapleader      = ','
let maplocalleader = ','

augroup vimrc
  autocmd!
augroup END

set nu
set autoindent
set smartindent
set lazyredraw
set laststatus=2
set showcmd
set visualbell
set backspace=indent,eol,start
set timeoutlen=500
set whichwrap=b,s
set shortmess=aIT
set hlsearch " CTRL-L / CTRL-R W
set incsearch
set hidden
set ignorecase smartcase
set wildmenu
set wildmode=full
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set scrolloff=5
set encoding=utf-8
set list
set listchars=tab:\|\ ,
set virtualedit=block
set nojoinspaces
set diffopt=filler,vertical
set autoread
set clipboard=unnamed
set foldmethod=indent   "fold based on indent
set foldnestmax=10       "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevelstart=99
set grepformat=%f:%l:%c:%m,%f:%l:%m
set completeopt=menuone,preview
set cursorline
set nrformats=hex
set encoding=UTF-8
set relativenumber
set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

silent! set cryptmethod=blowfish2

set modelines=2
set synmaxcol=1000

" Color
if (has("termguicolors"))
  set termguicolors
endif

let g:nord_italic_comments = 1
let g:nord_uniform_diff_background = 1
let g:nord_bold_vertical_split_line = 1
let g:nord_uniform_status_lines = 1
let g:nord_cursor_line_number_background = 1
colorscheme nord

" Annoying temporary files
set backupdir=/tmp//,.
set directory=/tmp//,.
set undodir=/tmp//,.

" set complete=.,w,b,u,t
set complete-=i

" mouse
silent! set ttymouse=xterm2
set mouse=n

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline

" FOOBAR=~/<CTRL-><CTRL-F>
set isfname-==

if has('gui_running')
  set guifont=Menlo:h14 columns=80 lines=40
  silent! colo seoul256-light
else
  silent! colo seoul256
endif

" ============================================================================
" MAPPINGS
" ============================================================================

" ----------------------------------------------------------------------------
" Basic mappings
" ----------------------------------------------------------------------------

" noremap <C-F> <C-D>
" noremap <C-B> <C-U>

" Elixir
nnoremap <leader>mf :MixFormat<cr>
inoremap <leader>mf <esc>:MixFormat<cr>

" Open new line below and above current line
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" Save
inoremap <leader>zz <esc>:update<cr>:q<cr>
nnoremap <leader>zz :update<cr>:q<cr>
inoremap <C-s>     <esc>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>w :update<cr>

" Disable CTRL-A on tmux or on screen
if $TERM =~ 'screen'
  nnoremap <C-a> <nop>
  nnoremap <Leader><C-a> <C-a>
endif

" Quit
inoremap <C-Q>     <esc>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" Tags
" nnoremap <C-]> g<C-]>
" nnoremap g[ :pop<cr>

" <leader>n | NERD Tree
function! OpenNERDTreeAndFind()
  if &modifiable && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
  else
    NERDTreeToggle
  endif
endfunction
map <c-n> :NERDTreeToggle<cr>
map <Leader>p :call OpenNERDTreeAndFind()<cr>

" jk | Escaping!
inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>

" Movement in insert mode
" inoremap <C-h> <C-o>h
" inoremap <C-l> <C-o>a
" inoremap <C-j> <C-o>j
" inoremap <C-k> <C-o>k
" inoremap <C-^> <C-o><C-^>

" Movement in normal mode
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Make Y behave like other capitals
nnoremap Y y$

" qq to record, Q to replay
" qq to record, Q to replay
" qq to record, Q to replay
nnoremap Q @q

" Zoom
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <leader>z :call <sid>zoom()<cr>

" Last inserted text
nnoremap g. :normal! `[v`]<cr><left>

" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
" nnoremap ]] :bnext<cr>
" nnoremap [[ :bprev<cr>
nnoremap <C-b> :bd<cr>
nnoremap <C-b> :bd<cr>

" ----------------------------------------------------------------------------
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" ----------------------------------------------------------------------------
" :Chomp
" ----------------------------------------------------------------------------
command! Chomp %s/\s\+$// | normal! ``

" ----------------------------------------------------------------------------
" Open FILENAME:LINE:COL
" ----------------------------------------------------------------------------
function! s:goto_line()
  let tokens = split(expand('%'), ':')
  if len(tokens) <= 1 || !filereadable(tokens[0])
    return
  endif

  let file = tokens[0]
  let rest = map(tokens[1:], 'str2nr(v:val)')
  let line = get(rest, 0, 1)
  let col  = get(rest, 1, 1)
  bd!
  silent execute 'e' file
  execute printf('normal! %dG%d|', line, col)
endfunction

autocmd vimrc BufNewFile * nested call s:goto_line()

" ----------------------------------------------------------------------------
" vim-commentary
" ----------------------------------------------------------------------------
map  <Leader>/  <Plug>Commentary
nmap <Leader>// <Plug>CommentaryLine

" ----------------------------------------------------------------------------
" NERDTree
" ----------------------------------------------------------------------------
let NERDTreeNodeDelimiter = "\u00a0"
let NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
let NERDTreeLimitedSyntax = 1
let NERDTreeIgnore = ['_build$', 'deps', 'node_modules', '\~$']
let g:webdevicons_enable_nerdtree = 0
let g:NERDTreeGitStatusUseNerdFonts = 0

" ----------------------------------------------------------------------------
" <Enter> | vim-easy-align
" ----------------------------------------------------------------------------
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '\': { 'pattern': '\\' },
\ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['!Comment'] },
\ ']': {
\     'pattern':       '\]\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       ')\zs',
\     'left_margin':   0,
\     'right_margin':  1,
\     'stick_to_left': 0
\   },
\ 'f': {
\     'pattern': ' \(\S\+(\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   },
\ 'd': {
\     'pattern': ' \ze\S\+\s*[;=]',
\     'left_margin': 0,
\     'right_margin': 0
\   }
\ }

" Start interactive EasyAlign in visual mode
xmap <Leader>= <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
nmap <Leader>= <Plug>(EasyAlign)
nmap <Leader>== ga_

xmap <Leader>=   <Plug>(LiveEasyAlign)

" ----------------------------------------------------------------------------
" vim-signify
" ----------------------------------------------------------------------------
let g:signify_vcs_list = ['git']
let g:signify_sign_add          = '+'
let g:signify_sign_change       = '~'
let g:signify_sign_changedelete = '-'

" ----------------------------------------------------------------------------
" ALE
" ----------------------------------------------------------------------------
let g:ale_linters = {'java': [], 'yaml': [], 'scala': [], 'clojure': [], 'graphql': ['gqlint'], 'elixir': []}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\ }
" let g:ale_fixers = {'ruby': ['rubocop']}
" let g:ale_lint_delay = 1000
let g:ale_sign_warning = '──'
let g:ale_sign_error = '══'

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" " You can disable this option too
" " if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1

" ----------------------------------------------------------------------------
" Airline
" ----------------------------------------------------------------------------
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#format = 1
let g:airline#extensions#hunks#enabled = 0

let g:airline#extensions#default#layout = [[ 'a', 'b', 'c' ], [ 'x', 'y', 'error', 'warning' ]]

" ============================================================================
" FZF
" ============================================================================
" Hide statusline of terminal buffer
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
" nnoremap <silent> <Leader><Leader> :Files<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":GFiles\<cr>"
nnoremap <silent> <Leader><Enter>  :Buffers<CR>

" ============================================================================
" AUTOCMD {{{
" ============================================================================

" ----------------------------------------------------------------------------
" Close vim if the only window left open is a NERDTree 
" ----------------------------------------------------------------------------
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

augroup vimrc
  " File types
  au BufNewFile,BufRead Dockerfile*         set filetype=dockerfile

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste

  " Close preview window
  if exists('##CompleteDone')
    au CompleteDone * pclose
  else
    au InsertLeave * if !pumvisible() && (!exists('*getcmdwintype') || empty(getcmdwintype())) | pclose | endif
  endif

  " Automatic rename of tmux window
  if exists('$TMUX') && !exists('$NORENAME')
    au BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
    au VimLeave * call system('tmux set-window automatic-rename on')
  endif
augroup END
