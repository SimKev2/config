syn keyword pythonSelf self
highlight def link pythonSelf Special

syn match pythonDocCode ">>>\(.\)\+" contained
highlight link pythonDocCode Directory
syn match pythonDocArg ":\(\w\|\s\|\.\)\+:" contained
highlight link pythonDocArg Type

syn region pythonDocString start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend contains=pythonDocArg,pythonDocCode
highlight link pythonDocString String 

syn match pythonKwarg "\h\i*\ze==\@!"
highlight link pythonKwarg Type
