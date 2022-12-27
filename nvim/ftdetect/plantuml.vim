" Plantuml
au BufNewFile,BufRead *.puml set filetype=plantuml shiftwidth=2 expandtab
au FileType plantuml let g:plantuml_previewer#plantuml_jar_path = get(
    \  matchlist(system('cat `which plantuml` | grep plantuml.jar'), '\v.*\s[''"]?(\S+plantuml\.jar).*'),
    \  1,
    \  0
    \)
au FileType plantuml let g:plantuml_previewer#debug_mode=1
