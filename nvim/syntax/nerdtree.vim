" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'\*\=$#'
endfunction

call NERDTreeHighlightFile('md', 'blue', 'none', '#8BB6E0', 'none')

call NERDTreeHighlightFile('yml', 'yellow', 'none', '#EDEA8C', 'none')
call NERDTreeHighlightFile('yaml', 'yellow', 'none', '#EDEA8C', 'none')
call NERDTreeHighlightFile('json', 'yellow', 'none', '#EDEA8C', 'none')
call NERDTreeHighlightFile('ini', 'yellow', 'none', '#EDEA8C', 'none')
call NERDTreeHighlightFile('config', 'yellow', 'none', '#EDEA8C', 'none')
call NERDTreeHighlightFile('conf', 'yellow', 'none', '#EDEA8C', 'none')

call NERDTreeHighlightFile('sh', 'red', 'none', '#CC7474', 'none')

call NERDTreeHighlightFile('go', 'yellow', 'none', '#2ED2F2', 'none')

" call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', 'none')
" call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', 'none')
" call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', 'none')
" call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', 'none')
" call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', 'none')
" call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', 'none')
