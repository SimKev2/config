call plug#begin('~/.vim/plugged')
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
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

let g:gitgutter_realtime = 1

let g:netrw_list_hide='.*\.pyc$'

let g:python_host_prog = '/home/kevin/.virtualenvs/py2neovim/bin/python'
let g:python3_host_prog = '/home/kevin/.virtualenvs/py3neovim/bin/python'

let g:fzf_layout = { 'left': '~20%', 'window': '40vsplit enew' }
let $FZF_DEFAULT_COMMAND= 'ag --ignore-dir node_modules --ignore-dir angular --ignore *.pyc -g ""'
:nmap <C-f> :FZF<CR>

:nmap <F1> :YcmCompleter GoTo<CR>
:nmap <F2> :YcmCompleter GetDoc<CR>

autocmd BufWritePre *.py :%s/\s\+$//e

