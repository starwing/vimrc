
let b:old_efm = &efm
setl errorformat=luac:\ %f:%l:\ %m
setl fdm=syntax

if exists('b:undo_ftplugin')
    let b:undo_ftplugin.='|setl fdm<|let &efm=b:old_efm'
else
    let b:undo_ftplugin='setl fdm<|let &efm=b:old_efm'
endif
