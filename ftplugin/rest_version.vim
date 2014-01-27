
function! s:change_version()
    let time = strftime("%Y-%m-%d %H:%M:%S")
    let pos = winsaveview()

    $|if search('\c^:修改历史:', 'bW')
        call append(line('.'), '" 已于 '.time.' 写入')
    endif

    1|if search('\c^\s*:日期:', 'W')
        call setline(line('.'),
                    \ matchstr(getline('.'), '\c^\s*:日期:\s*').time)
    endif

    1|if search('\c^\s*:版本:', 'W')
        let pat = '^\s*:版本:\v.{-}\ze%(\s*\((\d+)\))=$'
        let pv = matchlist(getline('.'), pat)
        if empty(pv[1])
            call setline('.', getline('.').' (1)')
        else
            call setline('.', pv[0].' ('.(str2nr(pv[1], 10)+1).')')
        endif
    endif

    call winrestview(pos)
endfunction

augroup au_rest
    au!
    au BufWritePre *.rst silent call s:change_version()
augroup END
