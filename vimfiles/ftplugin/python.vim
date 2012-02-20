" if exists("b:did_ftplugin")
"     finish
" endif
" let b:did_ftplugin = 1

se nu sta et fdc=2 com=sO:#\ -,mO:#\ \ ,eO:##,:#

let b:undo_ftplugin = 'setl nu< sta< et< fdc<'

autocmd BufWritePre *.py call s:change_encoding()

function! s:change_encoding()
    let pat = '^\s*#\s*coding\s*[:=]\s*\(.\{-}\)\s*$'
    let pos = getpos('.')
    call cursor(1, 1)
    let linum = search(pat, 'nc', 10)

    if linum != 0 
        let line = getline(linum)
        let line = substitute(line, pat, '# vim'.': set fileencoding=\1 :', '')
        call setline(linum, line)
    endif
    call setpos('.', pos)
endfunction

