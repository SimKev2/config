let g:python_host_prog = '/Users/kevinsimons/envs/py2neovim/bin/python'
let g:python3_host_prog = '/Users/kevinsimons/envs/py3neovim/bin/python'

call plug#begin('~/.vim/plugged')
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'vim-syntastic/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'xolox/vim-misc'
Plug 'altercation/vim-colors-solarized'
call plug#end()

syntax enable
filetype plugin indent on
syntax on
let g:python_recommended_style = 0

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set nu
set ru
set autoread
au FocusGained,BufEnter * :checktime

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*/node_modules/*

let g:gitgutter_realtime = 1

let g:netrw_list_hide='.*\.pyc$'

let g:jedi#use_tabs_not_buffers = 1
let g:jedi#goto_definitions_command = "<F1>"

let g:fzf_layout = { 'left': '~20%', 'window': '40vsplit enew' }
let $FZF_DEFAULT_COMMAND= 'ag --vimgrep --ignore-dir node_modules --ignore-dir angular --ignore "*.pyc" -g ""'
:nmap <C-f> :FZF<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

autocmd BufWritePre *.py :%s/\s\+$//e

