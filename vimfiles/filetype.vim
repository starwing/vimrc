" Vim support file to detect file types
"

if exists("did_load_filetype")
    finish
endif

augroup filetypedetect
    au BufRead,BufNewFile *.cal      	setf text
    au BufRead,BufNewFile *.clj      	setf clojure
    au BufRead,BufNewFile *.i		setf swig 
    au BufRead,BufNewFile *.ll		setf llvm
    au BufRead,BufNewFile *.mlua     	setf meta.lua
    au BufRead,BufNewFile *.md     	setf markdown
    au BufRead,BufNewFile *.ninja     	setf ninja
    au BufRead,BufNewFile *.pro      	setf qmake
    au BufRead,BufNewFile *.proto     	setf proto
    au BufRead,BufNewFile *.rkt     	setf scheme
    au BufRead,BufNewFile *.rst     	setf rest
    au BufRead,BufNewFile *.scm     	setf scheme
    au BufRead,BufNewFile *.swg	setf swig 
    au BufRead,BufNewFile *.td     	setf tablegen
    au BufRead,BufNewFile *.txt	setf text
    au BufRead,BufNewFile *.wlua     	setf lua
    au BufRead,BufNewFile *Makefile* 	setf make
augroup END


