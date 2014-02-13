" packages.vim
" add runtimepath of complex plugins in &rtp/packages folder.

for path in split(globpath(&rtp, "packages"), '\n')
    let s:rtplist = split(glob(path."/*"), '\n')
    let s:rtp = ""
    for pp in filter(s:rtplist,
                \ "isdirectory(v:val) && v:val[-1:-1] != '~'")
        let s:rtp .= ",".pp
        if isdirectory(pp.'/after')
            let s:rtp .= ','.pp.'/after'
        endif
    endfor
    if s:rtp != "" | let &rtp .= s:rtp | endif
endfor

run! packages/*[^~]/plugin/*.vim
run! packages/*[^~]/after/plugin/*.vim
