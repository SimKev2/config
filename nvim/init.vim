call plug#begin('~/.vim/plugged')
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'xolox/vim-misc'
Plug 'altercation/vim-colors-solarized'
call plug#end()

syntax enable
filetype plugin indent on

set nu
set ru

syntax on
set tabstop=4
set shiftwidth=4
set expandtab

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*/node_modules/*

let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_dont_split = 'netrw'

let g:gitgutter_realtime = 1

let g:netrw_list_hide='.*\.pyc$'

let g:python_host_prog = '/home/kevin/.virtualenvs/py2neovim/bin/python'
let g:python3_host_prog = '/home/kevin/.virtualenvs/py3neovim/bin/python'

:nmap <F1> :YcmCompleter GoTo<CR>
:nmap <F2> :YcmCompleter GetDoc<CR>
:nmap <C-g> :CtrlPTag<CR>

