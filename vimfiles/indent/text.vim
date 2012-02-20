" Vim indent file
" Language:	plain text
" Maintainer:	StarWing
" Last Change:	2008-11-10 09:40:18

" Only Load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" indent for plain text {{{1
setlocal indentexpr=GetTextIndent()
setlocal smarttab

let b:undo_indent = "setl inde< sta<"

" }}}
" A small indent function for plain text {{{1
"
if exists('*GetTextIndent')
    finish
endif

func GetTextIndent()
    let cline = line('.')
    if cline == 2
        return &sw
    endif

    let nline = prevnonblank(cline - 1)
    if getline(cline - 1) =~ '^\s*$'
        if nline != 1 && (getline(nline - 1) =~ '^\s*$' || nline == 2)
            return indent(nline)
        else
            return indent(nline) + &sw
        endif
    else
        if nline != 1 && (getline(nline - 1) =~ '^\s*$' || nline == 2)
            return indent(nline) - &sw
        else
            return indent(nline)
        endif
    endif
endfunc
" }}}

" vim: ft=vim:fdm=marker:ts=4:sw=4:sta:et:nu
