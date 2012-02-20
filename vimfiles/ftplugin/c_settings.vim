" ==========================================================
" File Name:    c_settings.vim
" Author:       StarWing
" Version:      0.1
" Last Change:  2008-12-16 19:22:26
" ==========================================================
" Only do this when not done yet for this buffer {{{1

if exists("b:did_ftplugin") || !has('eval')
    finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo-=C

" functions {{{1

let s:cs = 'c_settings'
let s:cs_name = 'b:'.s:cs

let b:{s:cs} = {}
let b:{s:cs}.do = []
let b:{s:cs}.undo = []

function! s:set_do(do)
    call add(b:{s:cs}.do, a:do)
endfunction

function! s:set(do, undo)
    call add(b:{s:cs}.do, a:do)
    call add(b:{s:cs}.undo, a:undo)
endfunction

function! s:set_option(lhs, rhs)
    if a:rhs == '1'
        let b:{s:cs}.do += ['setl '.a:lhs]
    elseif a:rhs == '0'
        let b:{s:cs}.do += ['setl no'.a:lhs]
    else
        let b:{s:cs}.do += ['setl '.a:lhs.a:rhs]
    endif
    let b:{s:cs}.undo += ['let &l:'.a:lhs.'="'.escape(eval('&l:'.a:lhs), '"\').'"']
endfunction

function! s:set_var(var, val)
    if !exists(a:var)
        call add(b:{s:cs}.do, 'let '.a:var.' = "'.escape(a:val, '\"').'"')
        call add(b:{s:cs}.undo, 'unlet! '.a:var)
    endif
endfunction

function! s:do_settings(cmd)
    for cmd in b:{s:cs}[a:cmd]
        exec cmd
    endfor
endfunction

" Settings {{{1

" Generic Settings {{{2

call s:set_option('cindent', '1')
call s:set_option('comments', '=sO:/*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://')
call s:set_option('errorfile', '=errors.log')
call s:set_option('expandtab', '1')
call s:set_option('foldcolumn', '=2')
call s:set_option('foldlevel', '=99')
call s:set_option('foldmethod', '=syntax')
call s:set_option('formatoptions', '+=croqlmB')
call s:set_option('formatoptions', '-=t')
call s:set_option('makeprg', '=gcc\ %\ -o%<\ -Wall')
call s:set_option('number', '1')
call s:set_option('shiftwidth', '=4')
call s:set_option('sidescroll', '=1')
call s:set_option('sidescrolloff', '=4')
call s:set_option('smarttab', '1')
"call s:set_option('tabstop', '=4')
call s:set_option('wrap', '0')

" Omnifunc {{{2
" Set completion with CTRL-X CTRL-O to autoloaded function.

if exists('&ofu')
    if globpath(&rtp, 'autoload/omni/cpp') != ""
        call s:set('call omni#cpp#complete#Init()', 'setl ofu=')
        call s:set_var('b:cs_ctags_flags', '-R --c++-kinds=+p --fields=+iaS --extra=+q')
    else
        call s:set_option('ofu', '=ccomplete#Complete')
    endif
endif

" VMS special {{{2
" In VMS C keywords contain '$' characters.

if has("vms")
    call s:set_option('iskeyword', '+=$')
endif

" }}}2
" ----------------------------------------------------------
" Helpers {{{1

" AStyle and Ctags Support {{{2

if executable('astyle')
    call s:set_var('b:cs_astyle_flags', '-oO -snwpyYHU --style=attach --mode=c')

    function! Run_astyle()
        norm msHmt
        silent exec 'keep %!astyle '.b:cs_astyle_flags
        norm 'tzt`s
    endfunction

    call s:set('nmap <buffer><silent> <A-a> :call Run_astyle()<CR>',
                \ 'nunmap <buffer> <A-a>')
    call s:set('imap <buffer><silent> <A-a> <ESC><A-a>', 'iunmap <buffer> <A-a>')
endif

if executable("ctags")
    let $CTAGS_FLAGS = '-R --c++-kinds=+p --fields=+iaS --extra=+q'
    call s:set_var('b:cs_ctags_flags', $CTAGS_FLAGS)
    call s:set_var('b:cs_ctags_fname', 'tags.current')
    call s:set_do('call s:set_option("tags", "+=".escape(b:cs_ctags_fname, "\\"))')

    for dir in split(globpath(&rtp, 'tools/'), "\<NL>")
        if filereadable(dir.'systags')
            call s:set_option('tags',
                        \ '+='.escape(escape(dir, ' ').'systags', ' \'))
            break
        endif
    endfor

    function! Run_ctags(...)
        let source_name = (a:0 < 1 ? shellescape(expand('%')) : a:1)
        let output_name = (a:0 < 2 ? b:cs_ctags_fname : a:0)
        return system('ctags '.b:cs_ctags_flags.' -f'.output_name.' '.source_name)
    endfunction

    call s:set('nmap <buffer><silent> <A-t> :call Run_ctags()<CR>', 'nunmap <buffer> <A-t>')
    call s:set('imap <buffer><silent> <A-t> <ESC><A-t>a', 'iunmap <buffer> <A-t>')
endif

let s:bind_cmd = ""

if exists('*Run_astyle')
    let s:bind_cmd .= ":call Run_astyle()<CR>"
endif
if exists('*Run_ctags')
    let s:bind_cmd .= ":call Run_ctags()<CR>"
endif

if !empty(s:bind_cmd)
    call s:set('nmap <buffer><silent> <A-u> '.s:bind_cmd, 'unmap <buffer> <A-u>')
    call s:set('imap <buffer><silent> <A-u> <ESC><A-u>', 'iunmap <buffer> <A-u>')

    " if has('autocmd')
    "     call s:set('augroup cs_autocmd | exec "au BufWritePost <buffer> '.
    "                 \ ' exec \"norm \\<A-u>\"" | augroup END',
    "                 \ 'au! cs_autocmd')
    " endif
endif

unlet s:bind_cmd

" maps {{{2

if exists('g:CS_enable_maps') && g:CS_enable_maps == 1
    function! s:add_cr()
        let syn = synIDattr(synID(line('.'), col('.') - 1, 1), 'name')

        if syn =~ 'String' || (getline('.')[col('.')-3] == "'" && syn != 'cCharacter')
            return ''
        endif

        return "\n"
    endfunction

    call s:set('ino <buffer> ; ;<c-r>=<SID>add_cr()<CR>', 'iun <buffer> ;')
    call s:set('ino <buffer> { {<c-r>=<SID>add_cr()<CR>', 'iun <buffer> {')
    call s:set('ino <buffer> } }<c-r>=<SID>add_cr()<CR>', 'iun <buffer> }')
endif

" }}}2
" ----------------------------------------------------------
" variables {{{1

" Win32 filter {{{2
" Win32 can filter files in the browse dialog

if has("gui_win32")

    if &ft == "cpp"
        call s:set_var('b:browsefilter', "\C++ Source Files (*.cpp *.c++)\t*.cpp;*.c++\n" .
                    \ "\C Header Files (*.h)\t*.h\n" .
                    \ "\C Source Files (*.c)\t*.c\n" .
                    \ "All Files (*.*)\t*.*\n")
    elseif &ft == "ch"
        call s:set_var('b:browsefilter', "Ch Source Files (*.ch *.chf)\t*.ch;*.chf\n" .
                    \ "\C Header Files (*.h)\t*.h\n" .
                    \ "\C Source Files (*.c)\t*.c\n" .
                    \ "All Files (*.*)\t*.*\n")
    else
        call s:set_var('b:browsefilter', "\C Source Files (*.c)\t*.c\n" .
                    \ "\C Header Files (*.h)\t*.h\n" .
                    \ "Ch Source Files (*.ch *.chf)\t*.ch;*.chf\n" .
                    \ "\C++ Source Files (*.cpp *.c++)\t*.cpp;*.c++\n" .
                    \ "All Files (*.*)\t*.*\n")
    endif

endif

" Variables for matchit plugin {{{2
" When the matchit plugin is loaded, this makes the % command skip parens and
" braces in comments.

call s:set_var('b:match_words', &matchpairs)
call s:set_var('b:match_skip', 's:comment\|string\|character')

" }}}2
" ----------------------------------------------------------
" terminational work {{{1

" tricks to get current sid
map <SID>xx <SID>xx
exec 'let s:sid = "\'.maparg('<SID>xx')[:-3].'"'
unmap <SID>xx

call s:do_settings('do')
let b:undo_ftplugin = "call ".s:sid."do_settings('undo')"

let &cpo = s:cpo_save
unlet s:cpo_save

" }}}1
" vim: ft=vim:fdm=marker:sw=4:ts=4:et:nu
