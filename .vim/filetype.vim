augroup filetypedetect
  " Git commit message
  autocmd Filetype gitcommit tw=72 colorcolumn=73
  " Other text
  autocmd Filetype tex setlocal spell tw=80 colorcolumn=81
  autocmd Filteype text setlocal spell tw=72 colorcolumn=73
  autocmd Filteype markdown setlocal spell tw=72 colorcolumn=73
  " Disable autocomplete for text
  autocmd Filetype tex let g:deoplete#enable_at_startup = 0
  autocmd Filteype text let g:deoplete#enable_at_startup = 0
  autocmd Filteype markdown let g:deoplete#enable_at_startup = 0
augroup END
