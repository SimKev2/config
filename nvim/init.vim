let g:python_host_prog = expand('~/envs/py2neovim/bin/python')
let g:python3_host_prog = expand('~/envs/py3neovim/bin/python')

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" GUI
Plug 'itchyny/lightline.vim'
Plug 'w0rp/ale'
Plug 'machakann/vim-highlightedyank'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'airblade/vim-gitgutter'
Plug 'mileszs/ack.vim'

" Language Specific Support
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

" Completion manager plugins
Plug 'Shougo/deoplete.nvim'

Plug 'Shougo/echodoc.vim'

Plug 'jiangmiao/auto-pairs'
Plug 'SirVer/ultisnips'
call plug#end()

" =============================================================================
" # Plugin settings
" =============================================================================

syntax enable
syntax on

" Base16 
set background=dark
colorscheme base16-atelier-dune
hi Normal ctermbg=NONE
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Lightline
if !has('gui_running')
  set t_Co=256
endif

" NerdTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=50
let g:NERDTreeIgnore = ['\.pyc$']
let NERDTreeShowHidden=1

" Linter
let g:ale_sign_column_always = 1
" only lint on save
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1

let g:ale_linters = {
    \ 'dart': ['dartanalyzer'],
    \ }

let g:ale_fixers = {
    \ 'dart': ['remove_trailing_lines', 'trim_whitespace', 'dartfmt'],
    \ 'go': ['remove_trailing_lines', 'trim_whitespace', 'gofmt'],
    \ 'markdown': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['remove_trailing_lines', 'trim_whitespace', 'yapf']
    \ }

let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_all_targets = 1

" GitGutter
let g:gitgutter_realtime = 1

" Ack
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
map <C-p> :LAck!<Space>

" Python Completion
let g:python_highlight_all = 1
let g:python_recommended_style = 0
let g:deoplete#enable_at_startup = 1
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#goto_definitions_command = "<F1>"
let g:jedi#completions_enabled = 0

" Racer + rust
let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently = 1
let g:racer_cmd = expand("~/.cargo/bin/racer")
let g:racer_experimental_completer = 1

" LanguageClient
set hidden
let g:LanguageClient_serverCommands = {
    \ 'dart': ['dart_language_server'],
    \ 'dockerfile': ['docker-langserver', '--stdio'],
    \ 'go': ['go-langserver'],
    \ 'python': ['pyls'],
    \ 'ruby': ['solargraph', 'stdio'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'sh': ['bash-language-server', 'start']
    \ }
let g:LanguageClient_autoStart = 1
nnoremap <silent> gu :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>


" Completion
" no newline on enter
inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<C-n>\<C-y>":"\<C-y>"):"\<CR>")
" tab to select
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" FZF
let g:fzf_layout = { 'left': '~20%' }
let $FZF_DEFAULT_COMMAND= 'ag --vimgrep --ignore-dir node_modules --ignore-dir angular --ignore "*.pyc" -g ""'

" UltiSnips
let g:UltiSnipsSnippetsDir = $HOME."/.vim/.vimsnippets"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<leader>l"
let g:UltiSnipsSnippetDirectories=[
      \ "UltiSips",
      \ $HOME."/.vim/.vimsnippets"
\ ]
"      \ $HOME . '/.vim/plugged/vim-snippets/snippets'


" =============================================================================
" # Editor settings
" =============================================================================
set backspace=indent,eol,start

let g:netrw_list_hide='.*\.pyc$'
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

filetype plugin indent on
set encoding=utf-8
set nowrap
set nojoinspaces
set termguicolors
highlight ColorColumn ctermbg=235 guibg=#2c2d27
set signcolumn=yes

set splitright
set splitbelow

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set scroll=20

autocmd FileType ruby set shiftwidth=2

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

set nu
set ru
set autoread
au FocusGained,BufEnter * :checktime

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*/node_modules/*

:nmap <C-f> :FZF<CR>
" Yank to the clipboard
map <C-c> "*y

nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>


" =============================================================================
" # Autocommands
" =============================================================================
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.profile set filetype=sh

autocmd Filetype go set colorcolumn=120

autocmd Filetype html,xml,xsl,php source ~/.vim/scripts/closetag.vim

autocmd Filetype python set colorcolumn=80
autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr><C-o>

autocmd FileType rust nmap gs <Plug>(rust-def-split)
autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
autocmd Filetype rust set colorcolumn=100

autocmd Filetype markdown,yaml set colorcolumn=120

" Terminal Function
function! NewTerm(height)
    16split
    terminal
    setlocal nonumber
    setlocal norelativenumber
    setlocal signcolumn=no
    setlocal colorcolumn=
    startinsert!
endfunction

nnoremap <F9> :call NewTerm(16)<CR>

