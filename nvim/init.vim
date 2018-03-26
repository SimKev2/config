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

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'airblade/vim-gitgutter'

" Language Specific Support
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'roxma/nvim-completion-manager'
Plug 'roxma/nvim-cm-racer'

" Completion manager plugins
Plug 'Shougo/deoplete.nvim'
Plug 'davidhalter/jedi-vim', {'for': 'python'}

Plug 'Shougo/echodoc.vim'
call plug#end()

" =============================================================================
" # Plugin settings
" =============================================================================

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

" Linter
let g:ale_sign_column_always = 1
" only lint on save
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 0
let g:ale_lint_on_enter = 0
let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_all_targets = 1

" GitGutter
let g:gitgutter_realtime = 1

" Python Completion
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
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Completion
" newline on enter
inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<C-n>\<C-y>":"\<C-y>"):"\<CR>")
" tab to select
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" FZF
let g:fzf_layout = { 'left': '~20%' }
let $FZF_DEFAULT_COMMAND= 'ag --vimgrep --ignore-dir node_modules --ignore-dir angular --ignore "*.pyc" -g ""'


" =============================================================================
" # Editor settings
" =============================================================================
let g:netrw_list_hide='.*\.pyc$'

filetype plugin indent on
syntax enable
syntax on
set encoding=utf-8
set nowrap
set nojoinspaces
set termguicolors

set splitright
set splitbelow

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

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
autocmd Filetype html,xml,xsl,php source ~/.vim/scripts/closetag.vim

autocmd Filetype python set colorcolumn=80

autocmd FileType rust nmap gs <Plug>(rust-def-split)
autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)
autocmd Filetype rust set colorcolumn=100

autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.profile set filetype=sh

autocmd BufWritePre *.py :%s/\s\+$//e

