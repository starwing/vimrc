" if exists("b:did_ftplugin")
"     finish
" endif
" let b:did_ftplugin = 1


setl ai nu et sta ts=8 sw=4 fdc=2 com=b:..
setl fo+=tn
setl flp=^\\s*\\%(\\d\\+[\\]:.)}\\t\ ]\\\|[-+*]\\)\\s*
let b:undo_ftplugin = 'setl ai< nu< et< sta< ts< sw< fdc< com< fo< flp<'

