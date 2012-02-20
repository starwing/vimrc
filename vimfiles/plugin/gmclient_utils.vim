if exists('loaded_gmclient_utils')
    "finish
endif
let g:loaded_gmclient_utils = 1

function! Get_other_name(args)
    let fname = expand('%')

    if a:args !~ '^\s*$'
        let fname = fnamemodify(a:args, ':p')
        exec 'edit! '.fname
    else
        let fname = fnamemodify(fname, ':p')
    endif

    if fname =~ '\v\c<GMClient(\d*)V5>'
        return substitute(fname, '\v\c<GMClient(\d*)V5>', 'GMClient\1', '')
    else
        return substitute(fname, '\v\c<GMClient(\d*)>', 'GMClient\1V5', '')
    endif
endfunction

function! Get_other_version(args, version)
    let fname = expand('%')

    if a:args !~ '^\s*$'
        let fname = fnamemodify(a:args, ':p')
        exec 'edit! '.fname
    else
        let fname = fnamemodify(fname, ':p')
    endif

    if fname =~ '\c\<GMClient-pub\>'
        return substitute(fname, '\v\c<GMClient(\w*)-pub>', 'GMClient'.a:version.'\1', '')
    else
        return substitute(fname, '\v\c<GMClient'.a:version.'(\w*)>', 'GMClient\1-pub', '')
    endif
endfunction

command! -complete=file -nargs=? -count=1 GMCDiff 
            \  if <count> == 1
            \|     exec 'diffs '.Get_other_name(<q-args>)
            \| else
            \|     exec 'diffs '.Get_other_version(<q-args>, <count>)
            \| endif
command! GMCFinish diffoff | wincmd o

map <leader>gd :<C-U>exec v:count1.'GMCDiff'<CR>
map <leader>gf :<C-U>GMCFinish<CR>
